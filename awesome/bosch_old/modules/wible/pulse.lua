local pulse =
{
   _NAME = "bosch.modules.wible.pulse";
   new  = function(custom_conf)
      bosch.modules.wible("pulse", custom_conf)
   end
}

local wibox = { widget = wibox.widget }

setmetatable
(
   pulse,                              -- this is the table
   {                                   -- this is the metatable
      __call = function(cls, ...)
         return cls.new(...)
      end,
   }
)





beautiful.init(conf.dir.core .. "theme.lua")

pulse.conf              = 
{
   refresh_time         = 3,
   view                 = 
   {
      analog_1_on       = beautiful.audio_analog_on_speakers,
      analog_2_on       = beautiful.audio_analog_on_jack,
      analog_off        = beautiful.audio_analog_off,
      hdmi_on           = beautiful.audio_hdmi_on,
      hdmi_off          = beautiful.audio_hdmi_off,
      bluetooth_on      = beautiful.audio_bluetooth_on,
      bluetooth_off     = beautiful.audio_bluetooth_off,
      default_pic       = beautiful.widget_void,
      default_txt       = "",
      active_alpha      = 1,
      inactive_alpha    = 0.3,
   },
   sink_ports           =
   {
      analog_1          = "analog-output-speaker",
      analog_2          = "analog-output-headphones",
      hdmi              = "hdmi-output-0",
      bluetooth         = "headset-output"
   },
   signal               = "volume",
}

-- requires pacmd command installed
pulse.command =
[[
pacmd list-sinks | sed -r 's/^[ ]*[\t]*//' | grep -e '^volume:' -e '^active port:' -e '^muted: ' -e '^[ \\* ]*index: ' | sed -r 's/^[^\/]*\/[ ]*([0-9]*)%.*$/volume: \1%/'
]]

function pulse.create(pconf)
   local view = pconf.view
   local sinks = {}
   local sinks_number = 0
   for k, _ in pairs(pconf.sink_ports) do
      local sink_name = k:gsub('_.', '')
      if not sinks[sink_name] then
         sinks[sink_name] = true
         sinks_number = sinks_number + 1
      end
   end
   local widgets = { }
   for i = 1, sinks_number * 2, 2 do
      widgets[i] = wibox.widget.imagebox(view.deafult_pic)
      widgets[i + 1] = wibox.widget.textbox(view.default_txt)
   end
   return widgets
end

function pulse.exec(output, pconf, widgets)
   -- Expected output variable:
   -- [* ]index: X
   -- volume: YY%
   -- muted: yes/no
   -- active port: <sink port name>

   local rows, nr = tricks.rows(output)
   -- Check if the output is correct: it must not be empty, and it must contain a multiple
   -- of 4 number of lines (4, 8, 12...). If the conditions are not followed, then don't do
   -- anything: the widgets won't be updated.
   if nr > 0 and nr % 4 == 0 then

      local next_widget_position = 1
      local index, sink, muted, volume, default_sink
      for i, line in ipairs(rows) do
         -- if the line is the first of a "quadruplet", then it's the index one.
         -- Take its value and if it has a "*" mark the sink as the default one
         local n = i % 4
         if n == 1 then
            index = tricks.start_from(line, "index: ")
            default_sink = line:match( "*") ~= nil
         -- second line of the quadruplet: volume
         elseif n == 2 then
            volume = tricks.start_from(line, "volume: ")
         -- third line of the quadruplet: muted
         elseif n == 3 then
            muted = tricks.start_from(line, "muted: ")
         -- fourth line of the quadruplet: sink/port name
         else -- if n == 0 then
            sink = line:sub(15, -2)

            -- After having extracted the sink/port name (from the last line of the
            -- quadruplet), then we have all information we need about the sink, so we can
            -- proceed with widgets update.
            --
            ---- As a first thing, we define a local function, which takes as parameters a
            ---- table of widgets "wtable", a boolean "ds" which tells us if the current one
            ---- is the actual default sink, a string "m" which tells if the sink is actually
            ---- muted, and two strings k and kk, eventually equal, which allow us to find the
            ---- keys related to current sink widgets into wtable.
            --local apply_widget = function (wtable, ds, m, k, kk)
            --   local pic_to_set
            --   if m == "yes" then
            --      pic_to_set = pics.off[kk]
            --   else
            --      pic_to_set = pics.on[kk]
            --   end
            local pic_to_set = false
            for k, v in pairs(pconf.sink_ports) do
               if v == sink then
                  local k_without_index = k:gsub('_.', '')
                  if muted == "yes" then
                     pic_to_set = pconf.view[k_without_index .. "_off"]
                  else
                     pic_to_set = pconf.view[k .. "_on"]
                  end
               end
            end
            local opacity =
               (default_sink and pconf.view.active_alpha)
               or pconf.view.inactive_alpha

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
            if pic_to_set and volume and index then
               --local is_connected = false
               
               local widget_position = next_widget_position
               widgets[widget_position].opacity = opacity
               widgets[widget_position + 1].opacity = opacity
               widgets[widget_position]:set_image(pic_to_set)
               widgets[widget_position + 1]:set_text(volume .. " ")
               next_widget_position = widget_position + 2 
               -- Delete all data variables before next iteration (this gives consistency to
               -- the check above)
               index = nil
               volume = nil
               muted = nil
               pic_to_set = nil
            end

         end
      end
      -- Set blank widgets for any sink actually not connected. This is needed to manage the
      -- situation in which we disconnect a sink "on the go". Without these instructions the
      -- widgets wouldn't "disappear" after a sink shut down.
      for i = next_widget_position, tricks.table_size(widgets), 2 do
         widgets[i]:set_image(pconf.view.default_pic)
         widgets[i + 1]:set_text(pconf.view.default_txt)
      end
      --naughty.notify({text = pconf.refresh_time .. ""})
   else
      -- ERROR
      gears.debug.print_error
      (
         debug.getinfo(1, "n").name .. ": nr doesn't follow specifications:"
      )
   end
end

return pulse
