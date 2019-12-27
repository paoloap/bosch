local focus_blink =
{
   _NAME = "bosch.modules.container.client.focus_blink",
   new   = function(custom_conf)
      bosch.modules.container.client("focus_blink", custom_conf)
   end
}


setmetatable
(
   focus_blink,
   {
      __call = function(cls, ...)
         return cls.init(...)
      end,
   }
)

local mod_table = conf.modules.client and conf.modules.client.focus_blink
focus_blink.conf =
{
   signal_delay   = 0.10,
   props          = { "!maximized", "!fullscreen" },
   flags          = { "!ghost" },
   layouts        = {  }
}


function focus_blink.create(conf_table)
   local self = setmetatable({}, focus_blink)
   local layout = wibox.layout.flex.horizontal()
   self.element = awful.titlebar
   (
      conf_table.apply_to,
      {
         position    = conf_table.position,
         bg_normal   = beautiful.focus_unselected,
         fg_normal   = beautiful.focus_unselected,
         bg_focus    = beautiful.focus_selected,
         fg_focus    = beautiful.focus_selected,
         size        = conf_table.size
      }
   )
   self.element:set_widget(layout)
   return self

end

function focus_blink.show(c)
   awful.titlebar.show(c, mod_table.position)
end
function focus_blink.hide(c)
   awful.titlebar.hide(c, mod_table.position)
end

--client.connect_signal
--(
--   "manage",
--   function (c) --, startup)
--      awful.titlebar.show(c, conf.modules.client.focus_blink.position)
--   end
--)


return focus_blink
