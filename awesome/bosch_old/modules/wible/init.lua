
local wible =
{
   __index      = wible,
   _NAME        = "bosch.modules.wible",
}

local tricks = tricks
local awful = require("awful")
local naughty = require("naughty")

wible.defined = { not_wible = { } }
for wname, _ in pairs(tricks.lua_in_dir(conf.dir.bosch .. "modules/wible/")) do
   wible.defined[wname] = require("bosch.modules.wible." .. wname)
      --naughty.notify({ text = k })
end

setmetatable
(
   wible,                              -- this is the table
   {                                   -- this is the metatable
      __call = function(cls, ...)
         return cls.new(...)
      end,
   }
)

function wible.new(w, custom_conf)
   if w and wible.defined[w] then
      local default_conf = wible.defined[w].conf
      if
         not default_conf.replicate
         and not ( custom_conf and custom_conf.replicate)
         and bosch.modules.wibles[w]
      then
         return bosch.modules.wibles[w]
      end
      local self = setmetatable({}, wible)
      self.conf            = { }
      if custom_conf then
         for k, v in pairs(default_conf) do
            self.conf[k] = custom_conf[k] or v
         end
         if not self.conf.refresh_time then
            self.conf.refresh_time = DEFAULT_REFRESH_TIME
         end
      else
         self.conf = default_conf
      end
      self.timer           = timer({ timeout = self.conf.refresh_time })
      self.widgets         = wible.defined[w].create(self.conf)
      self.timer:connect_signal
      (
         "timeout",
         function()
            awful.spawn.easy_async_with_shell
            (
               wible.defined[w].command,
               function(o)
                  self.output = o
                  wible.defined[w].exec
                  (
                     self.output,
                     self.conf,
                     self.widgets
                  )
               end
            )
   
         end
      )
      self.timer:start()
      self.refresh = function()
      if self.conf.not_refreshable then
         gears.debug.print_error
         (
            "this wible is not refreshable."
         )
      else
         self.timer:emit_signal("timeout")
      end
   end
   bosch.modules.wibles[w] = self
   return self

   elseif w and wible.defined.not_wible and wible.defined.not_wible[w] then
      if
         not ( custom_conf and custom_conf.replicate)
         and bosch.modules.wibles[w]
      then
         return bosch.modules.wibles[w]
      end
      local self = wible.defined.not_wible(w, custom_conf)

      bosch.modules.wibles[w] = self
      return self
   else
      local error_string = "the variable w doesn't exist."
      if w then
         error_string = "the wible " .. w .. " doesn't exist."
      end
      gears.debug.print_error
      (
         error_string
      )
   end

end

function wible.refresh(name)
   for s in screen do
      all_widgets[name .. "_" .. s.index]:refresh()
   end
end


return wible
