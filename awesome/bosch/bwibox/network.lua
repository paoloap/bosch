----------------------------------------------------------------------------
--- BOSCH - network.lua
--- Network and traffic widgets for Bosch top wibox
--- To do: Correct comments
-- @author schuppenflektor
-- @copyright 2016 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.6
-- @module bosch.bwibox.network
----------------------------------------------------------------------------

local network = { _NAME = "bosch.bwibox.network" }

local wibox = require("wibox")
local awful = require ("awful")
local beautiful = require("beautiful")

--- readfile local function returns connection parameters (as boolean values)
---  NOTE: it works only if wicd-cli returns output in italian language
-- @return first true if connected
-- @return second true if connecting
-- @return third true if disconnected
-- @return fourth true if using wi-fi
-- @return fifth true if using wired connection
function network.status()
  local netstatustimer = timer({ timeout = 3 })
  local neticon = wibox.widget.imagebox()
  local netstatus = wibox.widget.textbox()
  netstatustimer:connect_signal("timeout",function()
    local fnetw = io.open(config.scripts .. '/net_data',"r")
    local nettype = fnetw:read("*l")
    local status = fnetw:read("*l")
    local interface = fnetw:read("*l")
    local text = fnetw:read("*l")
    fnetw:close()
    if status == "disconnected" then
      neticon:set_image(beautiful.widget_disconnected)
    elseif status == "connecting" then
      neticon:set_image(beautiful.widget_connecting)
    elseif status == "connected" then
      if nettype == "wifi" then
	neticon:set_image(beautiful.widget_wifi)
      elseif nettype == "ethernet" then
	neticon:set_image(beautiful.widget_wired)
      elseif nettype == "usb" then
	neticon:set_image(beautiful.widget_usb)
      end
    end
    netstatus:set_text(text)
  end)
  netstatustimer:start()
  return neticon, netstatus

end

--- network.interface function returns connection interface (as a string)
--- NOTE: it actually returns 'wlo1' for wifi interface and 'eno1' for wired interface.
--- I think it's not so difficult to generalize it.
-- @return network interface in use
function network.traffic()
  local traffictimer = timer({ timeout = 2 })
  local trafficwidget = wibox.widget.textbox()
  local dnicon = wibox.widget.imagebox()
  local upicon = wibox.widget.imagebox()
  traffictimer:connect_signal("timeout",function()
    local ftrf = io.open(config.scripts .. '/traffic_data',"r")
    local download = ftrf:read("*l")
    local upload = ftrf:read("*l")
    local traffic = download .. "/" .. upload
    local dnum = tonumber(string.match(download,"%d+"))
    local unum = tonumber(string.match(upload,"%d+"))
    if dnum > 50 then
      dicon = beautiful.widget_netgoing
    else
      dicon = beautiful.widget_net
    end
    if unum > 50 then
      uicon = beautiful.widget_netupgoing
    else
      uicon = beautiful.widget_netup
    end
    dnicon:set_image(dicon)
    upicon:set_image(uicon)
    trafficwidget:set_text(traffic)
  end)
  traffictimer:start()
  return dnicon, upicon, trafficwidget
end

return network
