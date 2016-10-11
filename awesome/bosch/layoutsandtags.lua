local layoutsandtags = { _NAME = "bosch.layoutsandtags" }

local awful = require("awful")
local lain = require("lain")

layouts =
{
  awful.layout.suit.floating,
  lain.layout.uselesstile,
  lain.layout.centerfair,
  lain.layout.uselessfair,
  lain.layout.centerwork,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen
}

-- Lain: layout settings
lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.centerfair.nmaster = 3
lain.layout.centerfair.ncol = 1
lain.layout.centerwork.top_left = 0
lain.layout.centerwork.top_right = 1
lain.layout.centerwork.bottom_left = 2
lain.layout.centerwork.bottom_right = 3


  tags = {}
  
  tags[1] = awful.tag({"⚓", "%", "¶", "♥", "⚒", "#", "❏", "♬"  }, 1, {layouts[6], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[3]})
  if screen.count() == 2 then
    local fextmon = assert(io.popen("xrandr | grep ' connected ' | cut -d' ' -f1 | sed '2!d'"))
    local extmon = fextmon:read("*l")
    if extmon == "VGA1" then
      tags[2] = awful.tag({"⚒", "⚓"}, 2, {layouts[2], layouts[6]})
    else
      tags[2] = awful.tag({"❏", "⚓"}, 2, {layouts[2], layouts[6]})
    end
  end

function layoutsandtags.tags()
  return tags
end

function layoutsandtags.layouts()
  return layouts
end

return layoutsandtags
