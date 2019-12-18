local awful = require("awful")
local modules = require("bosch.modules")
local finger_catch = {}

setmetatable
(
   finger_catch,
   {
      __call = function(cls, ...)
         return cls.init(...)
      end,
   }
)

actions = bosch.actions

function finger_catch.init()
   local global_keys = {}
   setmetatable(global_keys, { __shl = function (t,v) t[#t+1]=v end })
   for action, keys in pairs(conf.keybindings.global) do
      local keys_num = tricks.table_size(keys)
      local slave_key = keys[keys_num]
      keys[keys_num] = nil
      local master_keys = keys
      local funct
      local props = conf.commands[action]
      if props then
         local signal = props[2]
         if signal then
            funct = function()
               awful.spawn.easy_async
               (
                  props[1],
                  function(output)
                     --engine.module.notify(props[2], output)
                     finger_catch.notify(props[2], output)
                  end
               )
            end
         else
            funct = function()
               awful.spawn(props[1])
            end
         end
      else
         funct = actions.global[action]
      end
      _= global_keys << awful.key( master_keys, slave_key, funct )
   end
   local master_key = { conf.modkey }
   for i = 1, 9 do
      local slave_key = "#" .. i + 9
      local funct = function()
         if conf.tiling.taglist_type == nil then --"noempty" then
            local tag_number = 0
            for _, tag in ipairs(mouse.screen.tags) do
               if next(tag:clients()) or tag.selected then
                  tag_number = tag_number + 1
                  if i == tag_number then
                     tag:view_only()
                  end
               end
            end
         elseif conf.tiling.taglist_type == "all" then
            mouse.screen.tags[i]:view_only()
         end
      end
      _= global_keys << awful.key( master_key, slave_key, funct )
   end
   for k, v in pairs(global_keys) do
      globalkeys = gears.table.join(globalkeys,v)
   end
   root.keys(globalkeys)

   -- SET PER-CLIENT KEYS AND BUTTONS
   local client_keys = {}
   setmetatable(client_keys, { __shl = function (t,v) t[#t+1]=v end })
   for action, keys in pairs(conf.keybindings.client) do
      local keys_num = tricks.table_size(keys)
      local slave_key = keys[keys_num]
      keys[keys_num] = nil
      local master_keys = keys
      local funct = actions.client[action]
      _= client_keys << awful.key( master_keys, slave_key, funct )
   end
   master_key = { conf.modkey, "Shift" }
   for j = 1, 9 do
      local slave_key = "#" .. j + 9
      local funct = function(c)
         c:move_to_tag(mouse.screen.tags[j])
      end
      _= client_keys << awful.key( master_key, slave_key, funct )
   end
   for k, v in pairs(client_keys) do
      clientkeys = gears.table.join(clientkeys,v)
   end

   local clientbuttons = {}
   clientbuttons = gears.table.join
   (
      clientbuttons,
      awful.button( { }, 1, function(c) client.focus = c; c:raise() end ),
      awful.button( { conf.modkey }, 1, awful.mouse.client.move ),
      awful.button( { conf.modkey }, 3, awful.mouse.client.resize )
   )

   -- SET RULES
   awful.rules.rules =
   {
      {
         rule = { },
         properties =
         {
            keys = clientkeys,
            buttons = clientbuttons,
         }
      }
   }

end

function finger_catch.notify(name, output)
   for n, w in pairs(bosch.modules.wibles) do
      --naughty.notify({ text = "ooooo"})
      if w.conf and w.conf.signal == name then
         w:refresh()
      end
   end
   local notification = output and tricks.split(output, "NOTIFY:")[2]
   if notification then
      local text = ""
      local rows, n = tricks.rows(notification)
      local title = gears.string.xml_escape(rows[1])
      if n > 1 then
         for i = 2, n, 1 do
            text = text .. rows[i] .. "\n"
         end
      end
      naughty.notify
      (
         {
            margin = 20,
            title = title,
            text = text
         }
      )
   end
end

return finger_catch
