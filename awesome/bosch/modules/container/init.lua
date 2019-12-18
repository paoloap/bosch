
local container =
{
   _NAME = "bosch.modules.container",
}

wibox = require("wibox")

local modules_dir = conf.dir.bosch .. "modules/container/"
local objects =
{
   screen = "index",
   client = "window"
}

container.defined = { }
setmetatable
(
   container,
   {
      __call = function(cls, ...)
         return cls.new(...)
      end,
   }
)


for obj, key in pairs(objects) do
   local def_table = tricks.lua_in_dir(modules_dir .. obj .. "/")
   container[obj] =
   {
      _NAME    = "bosch.modules.container." .. obj,
      defined  = { }
   }
   
   for name, def in pairs(def_table) do
      container[obj].defined[name] = require(container._NAME .. "." .. obj .. ".".. name)
   end
end

container.new = function(name, conf_table)
   self = setmetatable({}, container)
   self.name = name
   self.conf = conf_table

   for obj, key in pairs(objects) do
      local instance = container[obj].defined[name]
      if instance then
         local cont = instance.create(conf_table)
         self.element = cont.element
         self.children = cont.children
         local id
         if conf_table.apply_to then
            --naughty.notify({text = conf_table.apply_to[key] ..""})
            id = conf_table.apply_to[key]
            bosch.modules.containers[obj] = bosch.modules.containers[obj] or { }
            bosch.modules.containers[obj][id] = bosch.modules.containers[obj][id] or { }
            bosch.modules.containers[obj][id][name] = self
         end
         return self
      end
   end
end

function container:refresh(signal_name)
   for i, w in ipairs(self.children) do
      -- if not signal_name refresh all wibles in container except not refreshables
      if
         not w.conf.not_refreshable
         and ( ( w.conf.signal and w.conf.signal == signal_name ) or not signal_name )
      then
         w:refresh()
      end
   end
end

return container
