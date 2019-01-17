---------------------------------------------------------------------------
--- BOSCH - audio.lua
--- Audio widgets for Bosch top wibox
-- Released under GPL v3
-- NOTE: depends on pulseaudio package (pacmd command),
--       and mpd widget needs mpd installed
-- @author schuppenflektor
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.8
-- @module bosch.bwibox.audio
---------------------------------------------------------------------------

local audio = {
   _NAME = "bosch.bwibox.audio",
}

local wibox = require("wibox")
local awful = require ("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local tricks = require("bosch.utils.tricks")
require("bosch.config")


--- audio.pulse returns a table of widget, which are intended to be put on wibox following sinks
---             order in config.audio.sinks, and the timer which manages widgets refresh
-- @param first desired widgets refresh time in seconds
-- @return first volume widgets table
-- @return second the timer which controls volume widgets refresh
function audio.pulse(refresh)
   -- REFRESH stores is timer restart frequency, ACTIVE_ALPHA is the default sink widgets' opacity,
   -- INACTIVE_ALPHA is other sink widgets' opacity
   local ACTIVE_ALPHA   = 1
   local INACTIVE_ALPHA = 0.3
   -- pics is a tabel which stores all widget icons, taken from theme
   local pics           =
   {
      void              = beautiful.widget_void;
      on                = {};
      off               = {}
   }
   for k, s in pairs(config.audio.sinks) do
      if type(s) == "table" then
         for kk in pairs(s) do
            pics.on[kk] = beautiful["audio_" .. k .. "_on_" .. kk]
         end
      else
         pics.on[k] = beautiful["audio_" .. k .. "_on"]
      end
      pics.off[k] = beautiful["audio_" .. k .. "_off"]
   end
   -- bscript is a string which contains the command which takes raw pulseaudio volume information
   local bscript        =
   [[
      pacmd list-sinks | sed -r 's/^[ ]*[\t]*//' | grep -e '^volume:' -e '^active port:' -e '^muted: ' -e '^[ \\* ]*index: '
   ]]

   -- Create a table named pwidgets which will contain all the widgets related to pulseaudio volume
   -- Each widget is associated to a key based on config.audio.sinks elements: an imagebox and
   -- a textbox for every sink, marked by a key like "sinkname_pic". The function by default creates
   -- two "empty" widgets for every sink. All widgets will be returned. audio.pulse() function is
   -- in fact about *refreshing* every widget with updated information
   local pwidgets = { }
   for k in pairs(config.audio.sinks) do
      pwidgets[k .. "_pic"] = wibox.widget.imagebox(pics.void)
      pwidgets[k .. "_txt"] = wibox.widget.textbox("")
   end

   -- ptimer is the timer which controls widget refresh timeout
   local ptimer         = timer({ timeout = refresh })

   ptimer:connect_signal
   (
      "timeout",
      function()
         -- Launch bscript asynchronously. When an output is produced the internal function is launched
         awful.spawn.easy_async_with_shell
         (
            bscript,
            function(output)
               -- Put every output line as a separate string into output_strings array
               -- If the system behaviour follows specifications (depending on pacmd command),
               -- for every sink there should be 4 lines: one contains the index number (and a "*"
               -- if the current one is the actual default sink), one is the sink/port name, one
               -- the "muted" stautus ("yes" or "no") and one the volume string.
               local output_strings, numStr = tricks.split(output, "\n")
               -- Check if the output is correct: it must not be empty, and it must contain a multiple
               -- of 4 number of lines (4, 8, 12...). If the conditions are not followed, then don't do
               -- anything: the widgets won't be updated.
               if numStr > 0 and numStr % 4 == 0 then
                  -- Create a table named sinks which will contain a dictionary of sinks names and
                  -- boolean values: by default every element will be set to false, but if the function
                  -- then finds out that a sink is connected, it will set the relative value to true.
                  -- This table is needed to know what sinks are not active in the current refresh,
                  -- because we want to set their widgets as "blank" ("void" image, empty string).
                  local sinks = { }
                  for k, v in pairs(config.audio.sinks) do
                     sinks[k] = false
                  end
                  local index, sink, muted, volume, default_sink
                  for i, line in ipairs(output_strings) do
                     -- if the line is the first of a "quadruplet", then it's the index one.
                     -- Take its value and if it has a "*" mark the sink as the default one
                     if i % 4 == 1 then
                        index = tricks.split(line, "index: ")[2]
                        default_sink = string.match(line, "*") ~= nil
                     -- second line of the quadruplet: volume
                     elseif i % 4 == 2 then
                        volume = tricks.split(line, " / ")[2]:gsub("%s", "")
                     -- third line of the quadruplet: muted
                     elseif i % 4 == 3 then
                        muted = tricks.split(line, " ")[2]
                     -- fourth line of the quadruplet: sink/port name
                     else -- if i % 4 == 0 then
                        sink = tricks.split(line,  "<")[2]:gsub("%>", "")
                        
                        -- After having extracted the sink/port name (from the last line of the
                        -- quadruplet), then we have all information we need about the sink, so we can
                        -- proceed with widgets update.
                        --
                        -- As a first thing, we define a local function, which takes as parameters a
                        -- table of widgets "wtable", a boolean "ds" which tells us if the current one
                        -- is the actual default sink, a string "m" which tells if the sink is actually
                        -- muted, and two strings k and kk, eventually equal, which allow us to find the
                        -- keys related to current sink widgets into wtable.
                        local apply_widget = function (wtable, ds, m, k, kk)
                           local pic_to_set
                           if m == "yes" then
                              pic_to_set = pics.off[k]
                           else
                              pic_to_set = pics.on[kk]
                           end
                           sinks[k] = true
			   local opacity = (ds and ACTIVE_ALPHA) or INACTIVE_ALPHA
                           --naughty.notify({text = "" .. opacity})
                           -- BUG: textbox opacity doesn't change properly
                           wtable[k .. "_pic"].opacity = opacity
                           wtable[k .. "_txt"].opacity = opacity
                           wtable[k .. "_pic"]:set_image(pic_to_set)
                           wtable[k .. "_txt"]:set_text(volume .. " ")

                        end
                        -- If all the variables needed to update the widget are set (they should) check
                        -- all the elements in config.audio.sink.
                        -- If the current element is a table, then the sink has more than one possible
                        -- port (as an example the analog output has speakers and jack ports): check if
                        -- any of port keys is equal to sink variable
                        -- If it's not a table, than just check if its key is equal to sink variable
                        -- The values k and kk are respectively sink key and (eventually) port name.
                        -- They are passed as parameters to apply_widget local function. Note that the
                        -- first parameter is by specification part of the keys of the related widgets
                        -- into pwidgets table. As an example wtable["hdmi_txt"] (or wtable.hdmi_txt) is
                        -- the textbox which stores hdmi volume.
                        if index and volume and muted and sink then
                           for k, s in pairs(config.audio.sinks) do
--                           naughty.notify({ text = sink })
                              if type(s) == "table" then
                                 for kk in pairs (s) do
                                    if s[kk] == sink then
                                       apply_widget(pwidgets, default_sink, muted, k, kk)
                                    end
                                 end
                              else
                                 if s == sink then
                                    apply_widget(pwidgets, default_sink, muted, k, k)
                                 end
                              end
                           end
                           -- Delete all data variables before next iteration (this gives consistency to
                           -- the check above)
                           index = nil
                           volume = nil
                           muted = nil
                           sink = nil
                        end
                        
                     end
                  end
                  -- Set blank widgets for any sink actually not connected. This is needed to manage the
                  -- situation in which we disconnect a sink "on the go". Without these instructions the
                  -- widgets wouldn't "disappear" after a sink shut down.
                  for k, v in pairs(config.audio.sinks) do
                     if not sinks[k] then
                        pwidgets[k .. "_pic"]:set_image(pics.void)
                        pwidgets[k .. "_txt"]:set_text("")
                     end
                  end

               end
            end
         )
      end
   )
   ptimer:start()
   return pwidgets, ptimer

end

--- audio.mpd returns a widget which represents the mpd song (if playing)
-- @param first desired widget refresh time in seconds
-- @return first mpd widget
-- @return second the timer which controls mpd widget refresh
function audio.mpd(refresh)
   local bscript = 'echo -e "status\ncurrentsong\nclose" | curl telnet://127.0.0.1:6600 -fsm 1 | grep -e "^state: " -e "^file: " -e "^Name: " -e "^Title: " -e "^Artist: "'
   local mtimer         = timer({ timeout = refresh })
   local mwidget = wibox.widget.textbox("")
   local mwidgets =
   {
      icon = wibox.widget.imagebox(beautiful.widget_void);
      text = wibox.widget.textbox("")
   }
   mtimer:connect_signal
   (
      "timeout",
      function()
         -- Launch bscript asynchronously. When an output is produced the internal function is launched
         awful.spawn.easy_async_with_shell
         (
            bscript,
            function(output)
               local output_strings = tricks.split(output, "\n")
               local state,file,name,artist,title
               for i, line in ipairs(output_strings) do
                  if string.match(line, "state: ") then
                     state = tricks.split(line,"state: ")[2]
                  elseif string.match(line, "file: ") then
                     file = tricks.split(line, "file: ")[2]
                  elseif string.match(line, "Name: ") then
                     name = tricks.split(line, "Name: ")[2]
                  elseif string.match(line, "Artist: ") then
                     artist = tricks.split(line, "Artist: ")[2]
                  elseif string.match(line, "Title: ") then
                     title = tricks.split(line, "Title: ")[2]
                  end
               end
               -- Will build the string to show into the variable 'song'. If the current mpd state
               -- is set to "stop", then we will not write anything. If the 'file' variable consists
               -- in a soundcloud URL, then 'song' will start with "[soundcloud]"; if it doesn't have
               -- any "http" piece into the file name, then we assume that it's a local file, and 'song'
               -- variable will start with "[local]. If the 'name' variable is set (like in soundcloud
               -- streams), then that will be the song name; if not (like common local mp3s) then we'll
               -- fulfill it using 'artist' and 'title' variables (which are the standard id3 tags).
               local song = " "
               if state == "stop" then
                  song = ""
               else
                  if string.match(file, "https://api.soundcloud.com/") then
                     mwidgets.icon:set_image(beautiful.audio_mpd_soundcloud)
                  elseif not string.match(file, "http") then
                     mwidgets.icon:set_image(beautiful.audio_mpd_local)
                  end
                  if name ~= nil then
                     song = song .. name .. " "
                  elseif artist ~= nil and title ~= nil then
                     song = song .. artist .. "/" .. title .. " "
                  end
               end
               mwidgets.text:set_text(song)
            end
         )
      end
   )
   mtimer:start()
   return mwidgets, mtimer
end

return audio
