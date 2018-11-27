---------------------------------------------------------------------------
--- BOSCH - krc.lua
--- Keybindings, Rules and Signals
-- Released under GPL v3
-- @author schuppenflektor
-- @copyright 2016-2018 Paolo Porcedda - porcedda(at)gmail.com
-- @module bosch
-- @release 0.7
---------------------------------------------------------------------------

local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

package.loaded.bosch = nil

local bosch = {
   bwibox = require("bosch.bwibox"),
   switcher = require("bosch.switcher"),
   tiling = require("bosch.tiling"),
   config = require("bosch.config"),
   krs = require("bosch.krs")
}

-- {{{ Error handling
-- Check if awesome finds an error during startup. If yes, adopt another config
-- (the code below will be executed only in fallback
if awesome.startup_errors then
   naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors
   })
end

-- Error managing after startup
do
   local in_error = false
   awesome.connect_signal("debug::error",
      function (err)
         -- Make sure we don't go into an endless error loop
         if in_error then
            return
         end
         in_error = true
         naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = err
         })
         in_error = false
      end
   )
end
-- }}}

-- {{{ Init elements

-- Set wallpaper
if beautiful.wallpaper then
   awful.screen.connect_for_each_screen(
      function(s)
         gears.wallpaper.maximized(beautiful.wallpaper, s, true)
      end
   )
end

-- Load the theme
beautiful.init(config.theme)

-- Load layouts, tags and top wibar
layouts = {}
tags = {}
wibar = {}
layouts = bosch.tiling.layouts
tags = bosch.tiling.tags()
wibar = bosch.bwibox.init()

return bosch
