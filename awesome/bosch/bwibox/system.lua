---------------------------------------------------------------------------
--- BOSCH - system.lua
--- CPU, memory and battery   widgets for Bosch top wibox
-- Released under GPL v3
-- NOTE: depends on 'systemctl suspend' command
-- @author schuppenflektor
-- @copyright 2016-2018 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.7.2
-- @module bosch.bwibox.system
---------------------------------------------------------------------------

local system = { _NAME = "bosch.bwibox.system" }
local wibox = require("wibox")
local awful = require ("awful")
local vicious = require("vicious")
local beautiful = require("beautiful")
local naughty = require("naughty")
--local audio = require("bosch.bwibox.audio")


--- system.cpu returns the actual cpu stress, and a cpu icon
-- @return first cpu icon
-- @return second cpu stress value
function system.cpu()
   local cpuicon = wibox.widget.imagebox()
   local cpuwidget = wibox.widget.textbox()
   vicious.register(cpuwidget, vicious.widgets.cpu, "$1% ")
   cpuicon:set_image(beautiful.widget_cpu)
   return cpuicon, cpuwidget
end

--- system.memory returns the actual ram usage, and a ram icon
-- @return first ram icon
-- @return second ram value
function system.memory()
   local memwidget = wibox.widget.textbox()
   vicious.register(memwidget, vicious.widgets.mem, "$1% ", 13)
   local memicon = wibox.widget.imagebox()
   memicon:set_image(beautiful.widget_mem)
   return memicon, memwidget
end

--- system.thermal returns the actual cpu temperature, and an icon which represents it
-- @return first thermal icon
-- @return second cpu temperature value (in celsius)
function system.thermal()
   local thermaltimer = timer({ timeout = 7 })
   local thermalicon = wibox.widget.imagebox()
   local thermalstatus = wibox.widget.textbox()
   thermaltimer:connect_signal("timeout", function()
      local ftherm = io.open(config.scripts .. '/thermal_data', "r")
      local status = ftherm:read("*number")
      if status < 55 then
         ticon = beautiful.widget_therm_low
      elseif status < 70 then
         ticon = beautiful.widget_therm_med
      elseif status < 80 then
         ticon = beautiful.widget_therm_high
      else
         ticon = beautiful.widget_therm_crit
      end
      thermalicon:set_image(ticon)
      thermalstatus:set_text(status .. "°C ")
   end)
   thermaltimer:start()
   return thermalicon, thermalstatus
end

--- system.battery returns the actual battery status, and an icon which represents it
-- @return first battery/ac icon
-- @return second battery percentage
function system.battery()
   
   local batterytimer = timer({ timeout = 5 })
   local batteryicon = wibox.widget.imagebox()
   local batterystatus = wibox.widget.textbox()
   batterytimer:connect_signal("timeout",function()
      local batString = {}
      batString = split(io.popen('acpi | cut -d" " -f3-'):read("*l"), ", ")
--      local batString = io.popen('acpi | cut -d" " -f3-'):read("*l")
      local status = batString[1]
      local perc = batString[2]:gsub("%%", "")
      if status == "Discharging" then
         if perc > 80 then
            bicon = beautiful.widget_bat_full
         elseif perc > 50 then
            bicon = beautiful.widget_bat_med
         elseif perc > 20 then
            bicon = beautiful.widget_bat_low
         else
            bicon = beautiful.widget_bat_empty
            if perc < 9 then
	   os.execute("systemctl suspend")
            end
         end
      else
         if perc == 100 then
            bicon = beautiful.widget_ac_full
         else
            bicon = beautiful.widget_ac
         end
      end
      batteryicon:set_image(bicon)
      batterystatus:set_text(perc .. "% ")
   end)
   batterytimer:start()
   return batteryicon, batterystatus
end

--- split takes a string and a delimiter, and returns an array with the string splitted
--- basing on delimiter, and the array size (an integer)
-- @param s the string we want to split
-- @param delimiter the string or char we want as split delimiter
-- @return result a string array which we get from splitting
-- @return i the number of strings contained in 'result'
function split(s, delimiter)
   local result = {}
   local i = 0
   for match in (s..delimiter):gmatch("(.-)"..delimiter) do
      table.insert(result, match)
	   i = i + 1
   end
   return result,i;
end

return system
