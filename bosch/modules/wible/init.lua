
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


function wible:_init(sink, wible_conf)
   if not wible_conf then
      wible_conf = conf.wible
   end
   local sink_conf      = wible_conf[sink] or conf.wible[sink]
   self.refresh         = sink_conf.refresh_time
   self.view            = sink_conf.view
   self.command         = sink_conf.command
   self.model           = sink_conf.model
   self.func            = sink_conf.func
   self.widgets         = generate_empty_widgets(self.view)
   self.timer           = timer({ timeout = self.refresh })

   self.timer:connect_signal
   (
      "timeout",
      function()
         awful.spawn.easy_async_with_shell
         (
            self.command,
            function(output)
               sink_conf.func(output, self.view, self.model, self.widgets)
            end
         )

      end
   )
   self.timer:start()
end

function wible:refresh()
   self.timer:emit_signal("timeout")
end

function wible:get_widgets()
   return self.widgets
end

