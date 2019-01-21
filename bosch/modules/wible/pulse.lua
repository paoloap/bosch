local pulse =
{
   _NAME = "bosch.bwibox.pulse";
}

function exec(output, view, model, widgets)

   local rows, nr = tricks.rows(output)
   -- Check if the output is correct: it must not be empty, and it must contain a multiple
   -- of 4 number of lines (4, 8, 12...). If the conditions are not followed, then don't do
   -- anything: the widgets won't be updated.
   if nr > 0 and nr % 4 == 0 then
      -- Create a table named sinks which will contain a dictionary of sinks names and
      -- boolean values: by default every element will be set to false, but if the function
      -- then finds out that a sink is connected, it will set the relative value to true.
      -- This table is needed to know what sinks are not active in the current refresh,
      -- because we want to set their widgets as "blank" ("void" image, empty string).
      local sinks = { }
      for k, _ in pairs(model) do
         sinks[k] = false
      end
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
            volume = tricks.split(line, " / ")[2]
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
            -- As a first thing, we define a local function, which takes as parameters a
            -- table of widgets "wtable", a boolean "ds" which tells us if the current one
            -- is the actual default sink, a string "m" which tells if the sink is actually
            -- muted, and two strings k and kk, eventually equal, which allow us to find the
            -- keys related to current sink widgets into wtable.
            local apply_widget = function (wtable, ds, m, k, kk)
               local pic_to_set
               if m == "yes" then
                  pic_to_set = pics.off[kk]
               else
                  pic_to_set = pics.on[kk]
               end
    	   local opacity = (ds and ACTIVE_ALPHA) or INACTIVE_ALPHA
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
               local is_connected = false
               for k, s in pairs(config.audio.sinks) do
                  if not is_connected then
                     if type(s) == "table" then
                        for kk in pairs (s) do
                           if s[kk] == sink then
                              apply_widget(pwidgets, default_sink, muted, k, kk)
                              is_connected = true
                           end
                        end
                     else
                        if s == sink then
                           apply_widget(pwidgets, default_sink, muted, k, k)
                           is_connected = true
                        end
                     end
                  end
                  sinks[k] = is_connected
               end
                 naughty.notify({text = "aaaa" .. sinks[1]})
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
   else
      -- ERROR
      print_error
      (
         debug.getinfo(1, "n").name .. ": nr doesn't follow specifications:"
      )
   end

