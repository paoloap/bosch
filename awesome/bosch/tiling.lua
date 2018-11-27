----------------------------------------------------------------------------
--- BOSCH - tiling.lua
--- This class contains the functions for tags and layouts initialization
--- NOTE: depends on xrandr package
--- To do: Comments
-- @author schuppenflektor
-- @copyright 2016-2018 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.7
---------------------------------------------------------------------------

local tiling = { _NAME = "bosch.tiling" }
local wibox = require("wibox")
local titlebar = require("awful.titlebar")
local beautiful = require("beautiful")
local awful = require("awful")
local lain = require("lain")
local naughty =  require("naughty")
require("bosch.config")

-- Lain layout settings
lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 2
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
-- lain.layout.centerwork.top_left = 0
-- lain.layout.centerwork.top_right = 1
-- lain.layout.centerwork.bottom_left = 2
-- lain.layout.centerwork.bottom_right = 3

local layout = {}
layout = {
    floating = awful.layout.suit.floating;
    tiling1 = awful.layout.suit.tile;
    tiling2 = lain.layout.centerwork;
    tiling3 = lain.layout.termfair.center;
    tiling4 = awful.layout.suit.spiral.dwindle;
    maximized = awful.layout.suit.max;
    fullscreen = awful.layout.suit.max.fullscreen;
    write = lain.layout.centerwork;
    music = lain.layout.centerwork;
    video = awful.layout.suit.tile
}

layouts = {}
local tags = {}

-- "Standard" layouts definition (independent by any configuration)
layouts = {
    layout.floating,
    layout.tiling1,
    layout.tiling2,
    layout.tiling3,
    layout.tiling4,
    layout.maximized,
    --layout.fullscreen
}

--- setDefLayout local method returns the proper default layout for any tag type.
--
-- @param ltype is the tag type ("floating", "maximized" etc)
-- @return the layout element related to the tag type (es awful.layout.suit.tile)
local function setDefLayout(ltype)
  if ltype == "floating" then return layout.floating
  elseif ltype == "tiling1" then return layout.tiling1
  elseif ltype == "tiling2" then return layout.tiling2
  elseif ltype == "tiling3" then return layout.tiling3
  elseif ltype == "maximized" then return layout.maximized
  elseif ltype == "fullscreen" then return layout.fullscreen
  elseif ltype == "music" then return layout.music
  elseif ltype == "video" then return layout.video
  elseif ltype == "write" then return layout.write
  else return layout.floating
  end
end

extmon = "no"
-- This command returns a file stream in which the first line is the number
-- of connected monitors, and the following ones are the (eventual)
-- connection types of secondary screen ("VGA1", "HDMI1", etc)
local xrandr = assert(io.popen(config.scripts .. "/tiling.sh"))
-- Put the number of connected monitors to local variable nmon
local nmon = xrandr:read("*n")
-- We need this to pass newline
xrandr:read("*l")


-- For every connected screen, load from config the desided scheme
for i=1,nmon do
  local screen = i
  -- For first screen, load default tags/layouts scheme
  if screen == 1 then
    scheme = config.tiling.schemes.default
  -- For each secondary screen, check if it's VGA or HDMI, and load the related
  -- tags/layouts scheme
  elseif screen > 1 then
    -- Read a new line from xrandr
    extmon = xrandr:read("*l")
    if extmon == "VGA1" then
      scheme = config.tiling.schemes.vga
    else
      scheme = config.tiling.schemes.hdmi
    end
  end

  -- The two arrays below will collects the tag names list and relative layouts
  -- for current screen, which will be passed as parameters to awful,tag.new
  local deftags = {}
  local deflayouts = {}
  local deficons = {}
  -- For every element of the scheme
  for j, elem in ipairs(scheme) do
    -- Get the tag type (maximized, floating, tiling1, etc.)
    local currentType = elem.type
    -- Execute setDefLayout function to set the right layout for current tag type 
    local currentLayout = setDefLayout(currentType)
    -- Get the tag name (which will be shownin bwibox taglist
    --local currentName = elem.name
    local currentName = ""
    local currentIcon = elem.icon
    -- insert currentName and currentLayout respectively on deftags and
    -- deflayouts arrays
    table.insert(deftags, currentName)
    table.insert(deflayouts, currentLayout)
    table.insert(deficons, currentIcon)
  end
  tags[screen] = awful.tag.new(deftags, screen, deflayouts)
  for k, elem in ipairs(tags[screen]) do
    tags[screen][k].icon = deficons[k]
  end
end

function tiling.extmon()
  return extmon
end

function tiling.focusBar(c)
  local layout = wibox.layout.flex.horizontal()
  local title = titlebar.widget.titlewidget(c)
  title:set_align("center")
  layout:add(title)
  focusBar = titlebar(c,
  {
    position = "bottom",
    bg_normal = beautiful.border_normal,
    fg_normal = beautiful.border_normal,
    bg_focus = beautiful.border_focus,
    fg_focus = beautiful.border_focus,
    size = 3
  })
  focusBar:set_widget(layout)
--  focusBar.show(c)
end

-- takes a client as parameter. if it has a default tag, then it returns it.
-- if it hasn't, it returns actual selected tag.
function tiling.getDefaultClientsTag(client)
  for i, ielem in ipairs(config.tiling.clients) do
    if client.class == ielem.class then
	  if not client.name == nil then
		local _s, _e,  nsubstr = string.find(client.name, "(%a+)")
	  end
      local _s, _e, isubstr = string.find(client.instance, "(%a+)")
      if client.name == ielem.name or client.instance == ielem.name or nsubstr == ielem.name or isubstr == ielem.name or ielem.name == "###" then
	local scheme = {}
	if extmon ~= "no" then
	  if extmon == "VGA1" then
	    scheme = config.tiling.schemes.vga
	  elseif extmon == "HDMI1" then
	    scheme = config.tiling.schemes.hdmi
	  end
	  for j, selem in ipairs(scheme) do
	    if ielem.type == selem.key then
	      return tags[2][j], ielem.forbidden, scheme
	    end
	  end
	end
	scheme = config.tiling.schemes.default
	for k, selem in ipairs(scheme) do
	  if ielem.type == selem.key then
	    return tags[1][k], ielem.forbidden, scheme
	  end
	end
      end
    end
  end
  return mouse.screen.selected_tag, {"notag"}, scheme
end

function tiling.openInTag(client)
  local t, forb, scheme = tiling.getDefaultClientsTag(client)
  for i, ielem in ipairs(scheme) do
    if i == mouse.screen.selected_tag.index then
      actualKey = ielem.key
    end
  end
  for j, jelem in ipairs(forb) do
    if jelem == actualKey then
      return t
    end
  end
  return mouse.screen.selected_tag
end

function tiling.saveClientsStatus()
  clientsListFile = io.open (config.bosch .. '/.cache/clients_status', "a")
  for s in screen do
    local clientsList = mouse.screen.clients
    if not clientsList == nil then
      local n = table.getn(clientsList)
      for c in clientsList do
      local pid = c.pid
      local tag = c.first_tag
      clientsListFile:write(c.pid .. ';;;' .. c.first_tag .. ';;;' .. s, "\n")
    end
  end
end
end


function tiling.layouts()
  return layouts
end

function tiling.tags()
  return tags
end

return tiling
