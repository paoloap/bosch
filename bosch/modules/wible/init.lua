
local wible =
{
   __index      = wible,
   _NAME        = "bosch.modules.wible",
}

local wible = {}
wible.__index = wible

setmetatable
(
   wible,
   {
      __call = function (cls, ...)
      local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function wible:_init(name, config_table)

   self.value = init
end

function wible:set_value(newval)
  self.value = newval
end

function wible:get_value()
  return self.value
end

