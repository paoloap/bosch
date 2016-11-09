local layoutsandtags = { _NAME = "bosch.layoutsandtags" }

local awful = require("awful")
local lain = require("lain")

layouts =
{
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  lain.layout.centerfair,
  --lain.layout.uselessfair,
  lain.layout.centerwork,
  awful.layout.suit.max,
  --lain.layout.cascadetile,
  awful.layout.suit.max.fullscreen
}

-- Lain: layout settings
lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 2
lain.layout.centerfair.nmaster = 3
lain.layout.centerfair.ncol = 1
lain.layout.centerwork.top_left = 0
lain.layout.centerwork.top_right = 1
lain.layout.centerwork.bottom_left = 2
lain.layout.centerwork.bottom_right = 3
-- lain.layout.cascadetile.cascade_offset_x = 0
-- lain.layout.cascadetile.cascade_offset_y = 0
-- lain.layout.cascadetile.extra_padding = 0
-- lain.layout.cascadetile.nmaster = 0
-- lain.layout.cascadetile.ncol = 0

  tags = {}
  
  extmon = "no"
  tags[1] = awful.tag({"⚓", "%", "¶", "⚡", "⚒", "#", "❏", "♬"  }, 1, {layouts[5], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[3]})
  if screen.count() == 2 then
    local fextmon = assert(io.popen("xrandr | grep ' connected ' | cut -d' ' -f1 | sed '2!d'"))
    extmon = fextmon:read("*l")
    if extmon == "VGA1" then
      tags[2] = awful.tag({"⚒", "⚓"}, 2, {layouts[2], layouts[5]})
    else
      tags[2] = awful.tag({"⚓", "❏", "♬"}, 2, {layouts[2], layouts[5], layouts [3]})
    end
  end

function layoutsandtags.tags()
  return tags
end

function layoutsandtags.layouts()
  return layouts
end

return layoutsandtags
