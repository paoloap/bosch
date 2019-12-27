local barble =
{
   _NAME = "bosch.modules.container.defined.screen.barble",
   new   = function(custom_conf)
      bosch.modules.container.screen("barble", custom_conf)
   end
}
local modules =
{
   wible = require("bosch.modules.wible"),
   not_wible = require("bosch.modules.not_wible")
}

setmetatable
(
   barble,
   {
      __call = function(cls, ...)
         return cls.init(...)
      end,
   }
)

function barble.create(bconf)
   local self = setmetatable({}, barble)
   self.children = {}
   self.element = awful.wibar
   (
      {
         position       = bconf.position,
         height         = bconf.height,
         screen         = bconf.apply_to.index,
      }
   )
   local layout = wibox.layout.align.horizontal()
   for k, v in pairs(bconf) do
      local splitted_key = tricks.split(k, "_")
      if splitted_key[1] == "elements" then
         local layout_part = splitted_key[2] 
         local sub_layout =
            (v.stacked and wibox.layout.stack()) or wibox.layout.fixed.horizontal()
         for i, element in ipairs(v) do
            local w_props = tricks.split(element, "_")
            local replicate = w_props[1] == ""
            local name = w_props[3] or w_props[2] or w_props[1]
            --naughty.notify({text = bconf.screen.index ..""})
            if name then
               local current_wible = bosch.modules.wible
               (
                  name,
                  {
                     replicate = replicate,
                     screen = bconf.apply_to
                  }
               )
               for j, widget in ipairs(current_wible.widgets) do
                  sub_layout:add(widget)
               end
               if not self.children[name] then
                  self.children[name] = current_wible
               end
            end
         end
         layout[layout_part] = sub_layout
      end
      self.element:set_widget(layout)
   end
   return self
end

return barble
