local bad_news = {}

setmetatable
(
   bad_news,
   {
      __call = function(cls, ...)
         return cls.init(...)
      end,
   }
)


function bad_news.init()
   -- ERROR HANDLING
   if awesome.startup_errors then
      naughty.notify
      (
         {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
         }
      )

      return true
   end
   -- Error managing after startup
   local in_error = false
   awesome.connect_signal("debug::error",
      function (err)
         -- Make sure we don't go into an endless error loop
         if in_error then
            return
         end
         in_error = true
         naughty.notify
         (
            {
               preset = naughty.config.presets.critical,
               title = "Oops, an error happened!",
               text = err
            }
         )
         in_error = false
      end
   )
end

return bad_news
