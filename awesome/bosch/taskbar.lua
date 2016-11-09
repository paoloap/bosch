----------------------------------------------------------------------------
--- Bosch Taskbar 
---
--- Taskbar is a separate wibox, activable with a keybind (mod+\) which shows
--- all clients only in maximized an fullscreen layouts, and minimized clients
--- in other layouts. The original taskbar place is substituted with focused
--- client title
--
-- @author paoloap
-- @copyright 2016 Paolo Porcedda
-- @release 0.1
-- @module bosch.taskbar
----------------------------------------------------------------------------

local taskbar = { _NAME = "bosch.taskbar" }
local ipairs = ipairs
local layout = require("awful.layout")
local widget = require("awful.widget")
local tag = require("awful.tag")
local wibox = require("wibox")
local instance = {  tasks = {},
		    wibox = nil }
local beautiful = require("beautiful")

--- taskbar.initialize draws a new wibox (just below the main one) and
--- puts a taskbar into it
-- @param screen
local function initialize(s)
  instance.wibox = wibox({})
  instance.tasks[s] = widget.tasklist(s, widget.tasklist.filter.minimizedcurrenttags, nil, {bg_normal = "#100d0a", fg_normal = "#d3c8a3"})
  instance.wibox.ontop = true
  local layout = wibox.layout.fixed.horizontal()
  layout:add(instance.tasks[s])
  instance.wibox:set_widget(layout)
  instance.wibox:geometry({x = screen[s].workarea.x, y = screen[s].workarea.y, width = screen[s].workarea.width, height = 16})
  instance.wibox.visible = true
end

--- taskbar.show shows taskbar in actual screen
-- @param screen
function taskbar.show(s)
  if not instance.wibox then
    initialize(s)
  elseif not instance.wibox.visible then
    initialize(s)
  else
    return
  end
end

--- taskbar.hide hides taskbar in actual screen
-- @param screen
function taskbar.hide(s)
  if instance.wibox then
    if instance.wibox.visible then
      instance.wibox.visible = false
    end
  end
end

--- taskbar.toggle toggles taskbar in actual screen
-- @param screen
function taskbar.toggle(s)
  if not instance.wibox then
    taskbar.show(s)
  elseif not instance.wibox.visible then
    taskbar.show(s)
  else
   taskbar.hide(s)
  end
end

return taskbar

