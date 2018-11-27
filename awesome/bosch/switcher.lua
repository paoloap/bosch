---------------------------------------------------------------------------
--- BOSCH - switcher.lua
--- Bosch Swither: to view all open clients in a maximized layout
-- Released under GPL v3
-- To do: Comments
-- @author schuppenflektor
-- @copyright 2016-2018 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.7
---------------------------------------------------------------------------


local switcher = { _NAME = "bosch.switcher" }

local wibox = require("wibox")
local titlebar = require("awful.titlebar")
local beautiful = require("beautiful")
local lain = require("lain")

function switcher.layout()
  return lain.layout.termfair
end

function switcher.init_titlebar(c)
  local layout = wibox.layout.flex.horizontal()
  local title = titlebar.widget.titlewidget(c)
  title:set_align("center")
  layout:add(title)
  switcherbar = titlebar(c,
  {
    position = "top",
    size = 20,
    fg_normal = beautiful.fg_switcher_normal,
    bg_normal = beautiful.bg_switcher_normal,
    fg_focus = beautiful.fg_switcher_focus,
    bg_focus = beautiful.bg_switcher_focus 
  })
  switcherbar:set_widget(layout)
  titlebar.hide(c)
end

return switcher
