---------------------------------------------------------------------------
--- BOSCH - system.lua
--- CPU, memory and battery  widgets for Bosch top wibox
-- Released under GPL v3
-- NOTE: depends on 'systemctl suspend' command
-- To Do: Correct comment
-- @author schuppenflektor
-- @copyright 2016 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.6
-- @module bosch.bwibox.system
---------------------------------------------------------------------------

local system = { _NAME = "bosch.bwibox.system" }
local wibox = require("wibox")
local awful = require ("awful")
local vicious = require("vicious")
local beautiful = require("beautiful")

function system.cpu()
  local cpuicon = wibox.widget.imagebox()
  local cpuwidget = wibox.widget.textbox()
  vicious.register(cpuwidget, vicious.widgets.cpu, "$1 % ")
  cpuicon:set_image(beautiful.widget_cpu)
  return cpuicon, cpuwidget
end


function system.memory()
  local memwidget = wibox.widget.textbox()
  vicious.register(memwidget, vicious.widgets.mem, "$1% ", 13)
  local memicon = wibox.widget.imagebox()
  memicon:set_image(beautiful.widget_mem)
  return memicon, memwidget
end


--- system.battery returns the actual battery status, and an icon which represents it
-- @return first battery/ac icon
-- @return second battery percentage
function system.battery()
  
  local batterytimer = timer({ timeout = 5 })
  local batteryicon = wibox.widget.imagebox()
  local batterystatus = wibox.widget.textbox()
  batterytimer:connect_signal("timeout",function()
    local fbat = io.open(config.scripts .. '/battery_data', "r")
    local status = fbat:read("*l")
    local perc = fbat:read("*number")
    if status == "Discharging" then
      if perc > 80 then
        icon = beautiful.widget_bat_full
      elseif perc > 50 then
        icon = beautiful.widget_bat_med
      elseif perc > 20 then
        icon = beautiful.widget_bat_low
      else
        icon = beautiful.widget_bat_empty
        if perc < 9 then
	  os.execute("systemctl suspend")
        end
      end
    else
      if perc == 100 then
        icon = beautiful.widget_ac_full
      else
        icon = beautiful.widget_ac
      end
    end
    batteryicon:set_image(icon)
    batterystatus:set_text(perc .. "%")
  end)
  batterytimer:start()
  return batteryicon, batterystatus
end

return system
