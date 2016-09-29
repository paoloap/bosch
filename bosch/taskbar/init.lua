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

--- taskbar.check_skip_taskbar_client takes client and screen as input,
--- and returns true if the client must be hidden
-- @param first client
-- @param second screen
-- @return true if client must be hidden, false otherwise
function taskbar.check_skip_taskbar_client(c, screen)
  local l = layout.get(screen)
  if c ~= nil then
    if l ~= layout.suit.max and l ~= layout.suit.max.fullscreen and not c.minimized then
      c.skip_taskbar = true
    else
      c.skip_taskbar = false
    end
  end
end

--- taskbar.check_skip_taskbar_screen takes screen as input, and returns
--- and returns the number of clients which must appear in taskbar for
--- actual screen, and boolean value which is true if screen hasn't
--- focused clients
-- @param screen
-- @return first number of clients showable in taskbar
-- @return second true if screen hasn't any focused client
function taskbar.check_skip_taskbar_screen(screen)
  local num = 0
  local empty = true
  local l = layout.get(screen)
  local tags = tag.gettags(screen)
  for i, t in ipairs(tags) do
    if t.selected then
      local clients = t.clients(t)
      for j, c in ipairs(clients) do
	if not c.minimized then
	  empty = false
	  if l ~= layout.suit.max and l ~= layout.suit.max.fullscreen then
	    c.skip_taskbar = true
	  else
	    c.skip_taskbar = false
	    num = num + 1
	  end
	else
	  c.skip_taskbar = false
	  num = num + 1
	end
      end
    end
  end
  return num, empty
end

function empty_screen(screen)
  local empty = true
end

--- taskbar.initialize draws a new wibox (just below the main one) and
--- puts a taskbar into it
-- @param screen
local function initialize(s)
  instance.wibox = wibox({})
  instance.tasks[s] = widget.tasklist(s, widget.tasklist.filter.currenttags)
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
  if taskbar.check_skip_taskbar_screen(s) == 0 then return end
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

