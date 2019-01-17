----------------------------------------------------------------------------
--- BOSCH - tiling.lua
--- This class contains the functions for tags and layouts initialization
--- NOTE: depends on xrandr package
--- To do: Comments
-- @author schuppenflektor
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.8
---------------------------------------------------------------------------

local tiling = { _NAME = "bosch.tiling" }

local wibox = require("wibox")
local titlebar = require("awful.titlebar")
local beautiful = require("beautiful")
local awful = require("awful")
local lain = require("lain")
local naughty =  require("naughty")
require("bosch.config")
local tricks = require("bosch.utils.tricks")

--- tiling.init initializes tags depending on connected screens, and return the tags matrix
function tiling.init()
   local tags = {}
   for s in screen do
     local scheme = tiling.screen_scheme(s)
     for i, tt in ipairs(scheme) do
        local t = awful.tag.add( tt.name,
        {
           icon = tt.icon,
           layout = tt.layout,
           screen = s,
        } )
        awful.tag.setproperty(t, "icon_only", 1)
     end
     table.insert(tags, s.tags)
   end
   local default_pids = dofile(config.tmpdir .. "/clients_status.lua")
   return tags, default_pids
end


function tiling.focus_bar(c)
   local layout = wibox.layout.flex.horizontal()
   local title = titlebar.widget.titlewidget(c)
   title:set_align("center")
   layout:add(title)
   focusBar = titlebar
   (
      c, 
      {
         position = "bottom",
         bg_normal = beautiful.border_normal,
         fg_normal = beautiful.border_normal,
         bg_focus = beautiful.border_focus,
         fg_focus = beautiful.border_focus,
         size = 3
      }
   )
   focusBar:set_widget(layout)
end


function tiling.open_in_tag(c)
   -- get the candidate tag: it will be the actual selected tag, if there is one, or the first tag
   -- in the current screen, if there isn't (tipically immediately after awesomewm restart)
   -- if candidatetag is not forbidden, then the client will open there, else it will open
   -- in default client's tag. default tag and forbidden tagtypes are taken through clientTagRules(c)
   local candidatetag
   if not mouse.screen.selected_tag then
      candidatetag = mouse.screen.tags[1]
   else 
      candidatetag = mouse.screen.selected_tag
   end
   local defaultTag, forbiddenTagTypes = tiling.client_tag_rules(c)
   for i, tagTypeKey in ipairs(forbiddenTagTypes) do
      if tagTypeKey == "no" or not tagTypeKey then
         return candidatetag
      end
      if candidatetag.name == config.tiling.tagtypes[tagTypeKey].name then
         return defaultTag
      end
   end
   return candidatetag
end


function tiling.save_clients_status()
   local file = config.tmpdir .. "/clients_status.lua"
   -- naughty.notify({text = "EEEEEE"})
   os.execute("rm " .. file)
   clients_list_file = io.open (file, "a")
   clients_list_file:write('return ',"\n")
   clients_list_file:write('{',"\n")
   for s in screen do
      local clients_list = s.all_clients
      if clients_list then
         for i, c in ipairs(clients_list) do
            local pid = c.pid
            local tag = c.first_tag
            clients_list_file:write("   [" .. c.pid .. "] = true;", "\n")
         end
      end
   end
   clients_list_file:write('}',"\n")
end

function tiling.screen_scheme(s)
   local dname
   local outputs = s.outputs
   for name in pairs(outputs) do
      dname = name
      outputs = nil
   end
   local displays = config.tiling.displays
   for _, d in ipairs(displays) do
      if d.name == dname then
         return d.scheme
      end
   end
end

function tiling.client_tag_rules(c)
   local cname = c.name or "###"
   for i, cli in ipairs(config.tiling.clients) do
      if c.class == cli.class and
      (
         cname == cli.name or
         c.instance == cli.name or
         cli.name == "###" or
         cname:find(cli.name) or
         c.instance:find(cli.name)
      ) then 
         for _, t in ipairs(mouse.screen.tags) do
            if t.name == config.tiling.tagtypes[cli.default].name then
	       return t, cli.forbidden
            end
         end
      end
   end
   return mouse.screen.selected_tag, { "no" }
end

return tiling
