---------------------------------------------------------------------------
--- BOSCH - actions/global.lua
--- Global actions: every function we might want to associate to
--- a keybinding or any other voluntary input action, no matter the env
-- Released under GPL v3
-- @author barrotes
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @module bosch
-- @release 0.9.0
---------------------------------------------------------------------------

--local bosch.core = bosch.core

local global = { _NAME = "bosch.actions.global" }

-- Function that I bind to super-j to make tests on stuff, its name is arbitrary...
function global.xrandr() 
   local a = client.focus.bosch_table
   local b = a and a.no_titlebar
   if b then naughty.notify({ text = "ooooooo" }) end
end

-- Restart Window Manager
function global.wm_restart()
   bosch.core.say_cheese()
   awesome.restart()
end

-- Quit Window Manager
global.wm_quit = awesome.quit

-- Open prompt-box on actual screen's wibar to execute a command
function global.run_cmd()
   local s = mouse.screen.index
   bosch.modules.containers.screen[s].barble.children.prompt.widgets[1]:run()
end

-- Go to left tag
function global.left_tag() lain.util.tag_view_nonempty(-1) end

-- Go to right tag
function global.right_tag() lain.util.tag_view_nonempty(1) end

-- Go to last opened tag
global.last_tag = awful.tag.history.restore

-- Focus on other screen
function global.screen_focus() awful.screen.focus_relative(1) end

-- Focus on next client in order
function global.tag_focus_left()
   local c = awful.client.next(1)
   bosch.core.pimp_client(c)
end

-- Focus on previous client in order
function global.tag_focus_right()
   local c = awful.client.next(-1)
   bosch.core.pimp_client(c)
end

-- Increase master width factor on actual tag
function global.left_inc() awful.tag.incmwfact(0.05) end

-- Decrease master width factor on actual tag
function global.right_inc() awful.tag.incmwfact(-0.05) end

-- Add a client to master column on actual tag
function global.left_add_row() awful.tag.incnmaster(1) end

-- Remove a client from master column on actual tag
function global.left_rem_row() awful.tag.incnmaster(-1) end

-- Add a slave column on actual tag
function global.right_add_col() awful.tag.incncol(1) end

-- Remove a slave column on actual tag
function global.right_rem_col() awful.tag.incncol(-1) end

-- Set next one in actual tag's layouts list
function global.layout_next()
   local tag = mouse.screen.selected_tag
   for i, layout in ipairs(tag.layouts) do
      if tag.layout == layout then
         if #tag.layouts == i then
            tag.layout = tag.layouts[1]
         else
            tag.layout = tag.layouts[i+1]
         end
         break
      end
   end
end

-- Set previous one in actual tag's layouts list
function global.layout_prev()
   local tag = mouse.screen.selected_tag
   if #tag.layouts ~= 1 then
      for i, layout in ipairs(tag.layouts) do
         if tag.layout == layout then
            if i == 1 then
               tag.layout = tag.layouts[#tag.layouts]
            else
               tag.layout = tag.layouts[i-1]
            end
            break
         end
      end
   end
end

-- Unminimize last minimized client in actual tag
function global.unminimize()
   local c = awful.client.restore(mouse.screen)
end

-- Toggle actual screen's bosch wibar
function global.toggle_wibar()
   local s = mouse.screen.index
   local wibar = bosch.modules.containers.screen[s].barble.element
   if wibar then
      --naughty.notify({text = "esiste"})
      wibar.visible = not wibar.visible
   end
end

-- If you are in a maximized layout, toggle switcher
function global.switcher()
   local tag = mouse.screen.selected_tag
   if tag.layout == layouts.max then
      for i, c in ipairs(tag:clients()) do
         awful.titlebar.show(c)
         --naughty.notify({ text = c.class})
      end
      tag.layout = layouts.switcher
   elseif tag.layout == layouts.switcher then
      for i, c in ipairs(tag:clients()) do
         awful.titlebar.hide(c)
         --naughty.notify({ text = c.class})
      end
      tag.layout = layouts.max
   end
end



return global
