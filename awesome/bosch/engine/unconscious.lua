local lain = require("lain")

local unconscious = { _NAME = "bosch.engine.unconscious" }
local core = bosch.core
local prop_list = core.prop_list

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol    = 1
lain.layout.termfair.center.nmaster = 2
lain.layout.termfair.center.ncol    = 1

setmetatable
(
   unconscious,
   {
      __call = function(cls, ...)
         return cls.init(...)
      end,
   }
)

function unconscious.init()

   unconscious.rebosch()
   unconscious.makeup()
   unconscious.tagging_logic()
   
end

function unconscious.tagging_logic()

   screen.connect_signal
   (
      "removed",
      function(s)
         for _, c in pairs(s.all_clients) do
            core.send_to(c, { background = true, ignore_screen = true } )
         end
         s = nil
      end
   )
   
   tag.connect_signal( "property::selected", core.weak_focus )
   
   local opened_windows = tricks.table_from_file(conf.dir.cache, "clients_status")
   client.connect_signal
   (
      "manage",
      function(c)
         if not c.bosch_table then
            core.boschiman(c)
         end
         local conf_table = c.bosch_table
         for name, mod_table in pairs(conf.modules.client) do
            mod_table.apply_to = c
            bosch.modules.container(name, mod_table)
         end
         local startup = not (opened_windows and opened_windows[c.window])
         if startup then
            core.send_to(c)
            if not c.bosch_table.background then
               --naughty.notify({text = "aeaeaeaeaeaeaeaea"})
               core.pimp_client(c)
            end
         end
      end
   )

   client.connect_signal
   (
      "property::minimized",
      function(c)
         if c.minimized then
            core.weak_focus(mouse.screen.selected_tag)
         else
            core.pimp_client(c)
         end
      end
   )
   
   client.connect_signal
   (
      "untagged",
      function(c)
         core.weak_focus(mouse.screen.selected_tag)
      end
   )
   
   client.connect_signal
   (
      "mouse::enter",
      function(c)
         if awful.client.focus.filter(c) then
            client.focus = c
         end
      end
   )
   
   client.connect_signal
   (
      "property::floating",
      function(c)
         core.pimp_client(c)
      end
   )
   client.connect_signal( "property::maximized", core.pimp_client )
end

function unconscious.makeup()
   beautiful.init(conf.dir.core .. "theme.lua")
   screen.connect_signal
   (
      "added",
      function(s)
         gears.wallpaper.fit(beautiful.wallpaper, screen.primary)
      end
   )
   screen.connect_signal
   (
      "removed",
      function(s)
         gears.wallpaper.fit(beautiful.wallpaper, screen.primary)
      end
   )
   client.connect_signal
   (
      "manage",
      function (c)
         c.border_width = beautiful.border_width
         c.border_color = beautiful.border_normal
      end
   )
   client.connect_signal
   (
      "property::maximized",
      function(c)
         c.border_width =
            ( c.maximized and beautiful.border_max )
            or beautiful.border_width
      end
   )

end

function unconscious.rebosch()

   screen.connect_signal( "added", unconscious.screen_bot )
   
   os.execute("xrandr --auto")
   awful.spawn.with_line_callback
   (
      "udevadm monitor --property",
      {
         stdout = function(line)
            if line:find("ID_FOR_SEAT=drm") then
               local command = "xrandr | grep -A3 ' connected' | sed 's/--/#/'"
               local connected_screens = {}
               local xrandr = io.popen(command):read("*all")
               local outputs, number = tricks.split(xrandr, "#\n")
               for _, display_info in ipairs(outputs) do
                  display_lines = tricks.rows(display_info)
                  local screen_name
                  local screen_res
                  local interpolated = false
                  for i, row in ipairs(display_lines) do
                     if i == 1 then
                        screen_name = tricks.split(row, " ")[1]
                     elseif i == 2 then
                        if not row:find("i") then
                           screen_res = row:match("[^ ]+")
                        else
                           interpolated = true
                        end
                     elseif i == 4 and interpolated then
                        interpolated = false
                        screen_res = row:match("[^ ]+")
                     end
                     if screen_name and screen_res then
                        connected_screens[screen_name] = screen_res
                        screen_name = nil
                        screen_res = nil
                     end
                  end
               end
               local main_screen, sec_screen, sec_res, sec_pos
               for name, res in pairs(connected_screens) do
                  local display_set = conf.tiling.displays[name]
                  if display_set and display_set[1] == "main" then
                     main_screen = name
                  elseif display_set then
                     sec_screen = name
                     sec_res = res
                     sec_pos = display_set[1]
                  end
               end
               local set_screens
               if tricks.table_size(connected_screens) == 2 then
                  set_screens = "xrandr --output " ..
                  sec_screen .. " --mode " .. sec_res ..
                  " --" .. sec_pos .. " " .. main_screen
               else
                  set_screens = "xrandr --auto"
               end

               awful.spawn(set_screens)

            end
         end,
      }
   )
   
   local restart_table = tricks.table_from_file(conf.dir.cache, "tiling_status")
   
   for s in screen do
      unconscious.screen_bot(s, restart_table and restart_table[s.index])
   end
   for _, r in pairs(awful.rules.rules) do
      if r.rule == { } then
         r.properties.focus            = awful.client.focus.filter
         r.properties.size_hints_honor = false
      end
   end

end


function unconscious.screen_bot(s, screen_table)
   gears.wallpaper.fit(beautiful.wallpaper, s)
   local screen_props = conf.tiling.displays[next(s.outputs)]
   for i, tag_name in ipairs(screen_props[2]) do
      local tag_table = screen_table and screen_table[i]
      local tag_info = conf.tiling.tags[tag_name]
      local default_layout = layouts[tag_info.layout_set[1]]
      local layout_table = {}
      for j, layout_name in ipairs(tag_info.layout_set) do
         layout_table[j] = layouts[layout_name]
      end
      local t = awful.tag.add
      (
         tag_name,
         {
            screen = s,
            icon = conf.dir.pics .. "tags/" .. tag_name .. ".png",
            layout =
               ((tag_table and tag_table.layout)
               and layouts[tag_info.layout_set[tag_table.layout]])
               or default_layout,
            layouts = layout_table,
         }
      )

      if tag_table then
         for i, prop in ipairs(prop_list) do
            t[prop] = tag_table[prop]
         end
      end
      t.icon_only = 1
   end
   for name, conf_table in pairs(conf.modules.screen) do
      conf_table.apply_to = s
      bosch.modules.container(name, conf_table)
   end
end


return unconscious


