local traffic =
{
   _NAME = "bosch.modules.wible.traffic";
   new  = function()
      bosch.modules.wible("traffic")
   end
}

local wibox = { widget = wibox.widget }

setmetatable
(
   traffic,                              -- this is the table
   {                                   -- this is the metatable
      __call = function(cls, ...)
         return cls.new(...)
      end,
   }
)




beautiful.init(conf.dir.core .. "theme.lua")

traffic.conf              =
{
   refresh_time         = 1,
   view                 =
   {
      default_down   = beautiful.network_download,
      default_up     = beautiful.network_upload,
      stress_down    = beautiful.network_download_stress,
      stress_up      = beautiful.network_upload_stress,
      default_txt    = "0.0/0.0",
   },
   down_threshold    = 100,
   up_threshold      = 100,
   cache_file        = conf.dir.cache .. "traffic.cache",
   not_refreshable
}

-- requires pacmd command installed
traffic.command =
[[
   interface=`ifconfig | grep -B1 broadcast | cut -d':' -f1 | head -1`;
   grep $interface /proc/net/dev | awk '{print $2,$10}';
]]


function traffic.create(tconf)
   local view = tconf.view
   return
   {
      wibox.widget.imagebox(view.default_down),
      wibox.widget.textbox(default_txt),
      wibox.widget.imagebox(view.default_up)
   }
end

function traffic.exec(output, tconf, widgets)
   -- Expected output variable:
   -- download_value upload_value
   
   local take_values = function(o, n, threshold, refresh)
      local num = math.floor(((tonumber(n) - tonumber(o)) / refresh ) / 1024 * 10) / 10
      local text = (num .. ""):gsub("%.",",")
      return text, num > threshold
   end
   
   local reset_widgets = function(widgets, view)
      widgets[1]:set_image(view.default_down)
      widgets[2]:set_text(view.default_txt)
      widgets[3]:set_image(view.default_up)
   end
   local output_new = tricks.rows(output)[1]
   local new, nn = tricks.split(output_new, " ")
   if not new or not nn == 2 then
      -- error: unexpected output from the command. the widget will not work
      gears.debug.print_error
      (
         "wrong command output: " .. output
      )
      reset_widgets(widgets, tconf.view)
      --naughty.notify({text = output }) 
      return
   end
   local file = io.open(tconf.cache_file, "r")
   if not file then
      -- error: the position can't be accessed
      reset_widgets
      (
         widgets,
         {
            default_down = tconf.view.default_down,
            default_up = tconf.view.default_up,
            default_txt = " ERROR "
         }
      )
      gears.debug.print_error
      (
         "you can't access cache file position: " .. tconf.cache_file
      )
      return
   end
   local output_old = tricks.rows(file:read("*all*"))[1]
   file:close()
   file = io.open(tconf.cache_file, "w+")
   file:write(output_new)
   file:close()
   
   local old, no = tricks.split(output_old, " ")
   if not old or not no == 2 then
      print_warning
      (
         [[
            the cache file contained wrong information, or
            was empty. it's normal if it's the first cycle.
         ]]
      )
      return
   end
   local down, dstress = take_values(old[1], new[1], tconf.down_threshold, tconf.refresh_time)
   local up, ustress = take_values(old[2], new[2], tconf.up_threshold, tconf.refresh_time)
   
   widgets[1]:set_image((dstress and tconf.view.stress_down) or tconf.view.default_down)
   widgets[2]:set_text(down .. "/" .. up)
   widgets[3]:set_image((ustress and tconf.view.stress_up) or tconf.view.default_up)
end

return traffic
