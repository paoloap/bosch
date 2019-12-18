local not_wible =
{
   __index      = not_wible,
   _NAME        = "bosch.modules.not_wible",
}

local awful = require("awful")

not_wible.separator = function(conf)
   local widget = wibox.widget.textbox("\\")
   return { widgets = { widget } }
end
not_wible.taglist = function(env)
   local widget = awful.widget.taglist
   (
      env.screen.index,
      awful.widget.taglist.filter.noempty
   )
   return { widgets = { widget } }
end
not_wible.prompt = function(conf)
   local widget = awful.widget.prompt()
   --   naughty.notify({text =  widget.fg})
   return { widgets = { widget } }
end
not_wible.titlebar = function(env)
   local widget = awful.widget.tasklist
   (
      env.screen.index,
      awful.widget.tasklist.filter.focused,
      nil,
      {
         fg_focus = beautiful.wibar_fg,
         bg_focus = beautiful.wibar_bg,
      }
   )
   return { widgets = { widget } }
end
not_wible.sysinfo = function()
   vicious = require("vicious")
   local cpu_pic = wibox.widget.imagebox()
   cpu_pic:set_image(beautiful.system_cpu)
   local cpu_txt = wibox.widget.textbox()
   vicious.register(cpu_txt, vicious.widgets.cpu, "$1% ")
   local mem_pic = wibox.widget.imagebox()
   mem_pic:set_image(beautiful.system_mem)
   local mem_txt = wibox.widget.textbox()
   vicious.register(mem_txt, vicious.widgets.mem, "$1% ", 13)
   return
   {
      widgets = { cpu_pic, cpu_txt, mem_pic, mem_txt },
      refresh = function()
         vicious.force({ cpu_txt, mem_txt })
      end
   }
end
not_wible.textclock = function(s)
   return { widgets = { awful.widget.textclock() } }
end
not_wible.layoutbox = function(s)
   return { widgets = { awful.widget.layoutbox() } }
end


setmetatable
(
   not_wible,
   {
      __call = function(cls, ...)
         return cls.new(...)
      end,
   }
)
function not_wible.new(name, env)
   self = setmetatable({}, not_wible)
   local result = not_wible[name](env)
   self.widgets = result.widgets
   self.refresh = result.refresh
   return self
end

function not_wible:refresh()
   self.refresh()
end

return not_wible
