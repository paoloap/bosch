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


function focus_blink.create(conf_table)
   local self = setmetatable({}, focus_blink)
   --   naughty.notify ( { text = beautiful.focus_selected .. "" } )
   local layout = wibox.layout.flex.horizontal()
   self.element = awful.titlebar
   (
      conf_table.client,
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

client.connect_signal
(
   "manage",
   function (c) --, startup)
      local mod_table = conf.modules.client.focus_blink
      mod_table.client = c
      bosch.modules.container("focus_blink", mod_table)
      awful.titlebar.show(c, mod_table.position)
   end
)


return focus_blink
