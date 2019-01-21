
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
   }
)


function wible:_init(w, wible_conf)
   
   if w then

      local w_conf         = wible_conf[w] or conf.wible[w]
      self.exec            = bosch.modules.wible[w].exec
      self.command         = bosch.modules.wible[w].command
      self.refresh         = w_conf.refresh_time
      self.view            = w_conf.view
      self.model           = w_conf.model
      self.widgets         = generate_empty_widgets(w_conf.max_number)
      self.timer           = timer({ timeout = self.refresh })
   
      self.timer:connect_signal
      (
         "timeout",
         function()
            awful.spawn.easy_async_with_shell
            (
               self.command,
               function(o)
                  self.output = o
                  self.exec
                  (
                     self.output,
                     self.view,
                     self.model,
                     self.widgets
                  )
               end
            )
   
         end
      )
      self.timer:start()

   else

      -- ERROR
      print_error(debug.getinfo(1, "n").name .. ": w is nil. It should contain wible's name.")

   end

end

function wible:refresh()
   self.timer:emit_signal("timeout")
end

function wible:get_widgets()
   return self.widgets
end

