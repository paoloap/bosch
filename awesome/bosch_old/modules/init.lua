
local modules =
{
   _NAME = "bosch.modules",
}

wibox = require("wibox")
gears = require("gears")


modules.wible     = require("bosch.modules.wible")
modules.container = require("bosch.modules.container")
modules.wibles    = { }
modules.containers = { }

setmetatable
(
   modules,
   {
      __call = function(cls, ...)
         return cls.init(...)
      end,
   }
)


--function modules.init(name, conf, obj)
--   self = setmetatable({}, modules)
--   self.conf = conf
--   if modules[name] then
--      local element, children = modules[name](conf, obj)
--      self.element = element
--      self.children = children
--   end
--   return self
--end


return modules
