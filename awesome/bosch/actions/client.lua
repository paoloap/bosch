---------------------------------------------------------------------------
--- BOSCH - actions/client.lua
--- Client-related actions: every function we might want to associate to
--- a keybinding or any other voluntary input action, into client env
-- Released under GPL v3
-- @author barrotes
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @module bosch
-- @release 0.9.0
---------------------------------------------------------------------------


local client = { _NAME = "bosch.actions.client" }

-- Quit client c
function client.quit(c) c:kill() end

-- Toggle fullscreen on client c
function client.fullscreen(c) c.fullscreen = not c.fullscreen end

-- Toggle maximization on client c
function client.maximize(c)
   local status = not c.maximized
   c.maximized = status
   c.maximized_horizontal = status
   c.maximized_vertical = status
end

-- Force client c to unmaximize (in case of buggy behaviour)
function client.force_unmax(c)
   c.maximized = false
   c.maximized_horizontal = false
   c.maximized_vertical = false
end

-- Toggle floating on client c
function client.float(c)
   c.floating = not c.floating
end

-- Minimize client c
function client.minimize(c) c.minimized = true end

-- Send client c to its default tag (defined on conf) but stay in actual tag
function client.default_tag_bg(c)
   local t, bg = bosch.core.send_to( c, { background = true, force_default = true } )
end

-- Send client c to its default tag (defined on conf) and pimp it
function client.default_tag_go(c)
   bosch.core.send_to( c, { force_default = true } )
   if not c.bosch_table.background then
      bosch.core.pimp_client(c)
   end
end

-- Send client c to right tag and pimp it
function client.tag_right(c)
   local actual_tag = c.screen.selected_tag.index
   local t
   if actual_tag == #c.screen.tags then
      t = c.screen.tags[1]
   else
      t = c.screen.tags[actual_tag + 1]
   end
   c:move_to_tag(c.screen.tags[t.index])
   bosch.core.pimp_client(c)
end

-- Send client c to left tag and pimp it
function client.tag_left(c)
   local actual_tag = c.screen.selected_tag.index
   local t
   if actual_tag == 1 then
      t = c.screen.tags[#c.screen.tags]
   else
      t = c.screen.tags[actual_tag - 1]
   end
   c:move_to_tag(c.screen.tags[t.index])
   bosch.core.pimp_client(c)
end

-- Send client c to other screen but keep focus on actual one
function client.screen(c)
   c:move_to_screen()
   awful.screen.focus_relative(1)
end

-- Send client c to other screen and pimp it
function client.screen_focus(c)
   c:move_to_screen()
   bosch.core.pimp_client(c)
end

-- Swap client c with next one in tag order
function client.swap_next(c)
   local other = awful.client.next(1)
   c:swap(other)
   bosch.core.pimp_client(c)
end

-- Swap client c with previous one in tag order
function client.swap_prev(c)
   local other = awful.client.next(-1)
   c:swap(other)
   bosch.core.pimp_client(c)
end


return client
