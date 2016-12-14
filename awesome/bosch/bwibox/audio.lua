---------------------------------------------------------------------------
--- BOSCH - audio.lua
--- Main Awesome WM user file
--- Audio widgets for Bosch top wibox
-- Released under GPL v3
-- NOTE: depends on pulseaudio package (pacmd command)
-- @author schuppenflektor
-- @copyright 2016 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.6
-- @module bosch.bwibox.audio
---------------------------------------------------------------------------

local audio = { _NAME = "bosch.bwibox.audio" }

local wibox = require("wibox")
local awful = require ("awful")
local beautiful = require("beautiful")

--- audio.volume returns the actual volume, and an icon which represents it
-- @return first volume icon
-- @return second volume value
function audio.volume()
  local volumetimer = timer({ timeout = 1 })
  local volumewidget = wibox.widget.textbox()
  local volumeicon = wibox.widget.imagebox()
  volumetimer:connect_signal("timeout", function()
    local fvol = io.open(config.scripts .. '/volume_data', "r")
    local port = fvol:read("*l")
    local status = fvol:read("*l")
    local volume = fvol:read("*l")
    volumewidget:set_text(volume .. " ")
    if status == "yes" then
      volumeicon:set_image(beautiful.widget_vol_off)
    else
      if port == "analog-output-speaker" then
	volumeicon:set_image(beautiful.widget_vol_on)
      elseif port == "analog-output-headphones" then
	volumeicon:set_image(beautiful.widget_jack)
      elseif port == "hdmi-output-0" then
	volumeicon:set_image(beautiful.widget_hdmi)
      end
    end
  end)
  volumetimer:start()
  return volumeicon, volumewidget
end

function audio.mpd()
  local mpdtimer = timer({ timeout = 7 })
  local mpdwidget = wibox.widget.textbox()
  mpdtimer:connect_signal("timeout", function()
    local fmpd = io.open(config.scripts .. '/mpd_data', "r")
    local status = fmpd:read("*l")
    local artist = fmpd:read("*l")
    local title = fmpd:read("*l")
    if status == "stop" then
      song = ""
    else
      song = artist .. "/" .. title
    end
    mpdwidget:set_text(song)
  end)
  mpdtimer:start()
  return mpdwidget
end

return audio
