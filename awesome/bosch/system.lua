----------------------------------------------------------------------------
--- System services (actually, only battery status)
---
--- NOTE: depends on acpi package
--
-- @author paoloap
-- @copyright 2016 Paolo Porcedda
-- @release 0.1
-- @module bosch.system
----------------------------------------------------------------------------
local system = { _NAME = "bosch.system" }

--- system.battery returns the actual battery status, and an icon which represents it
-- @return first battery/ac icon
-- @return second battery percentage
function system.battery()
  
  -- Cut the 'acpi' output, so that it only remains the percentage number;
  -- Put it into the file 'fperc', then put its content into the numeric
  -- variable 'perc'
  local fperc = assert(io.popen("acpi | cut -d' ' -f 4 | cut -d% -f 1", "r"))
  local perc = fperc:read("*number")

  -- Set value string with the percentage
  local value = perc .. '%'

  -- Cut the 'acpi' output, so that it only remains the status string (which
  -- can be " Full", " Charging" or " Discharging"; put it into the file
  -- 'fstatus', then put its content into the variable 'status'
  local fstatus = assert(io.popen("acpi | cut -d: -f 2,2 | cut -d, -f 1,1", "r"))
  local status = fstatus:read("*l")

  -- if status is " Discharging", set the proper icon, depending on charge
  -- status (0-19, 20-49, 50-79, 80-100). If the status is different
  -- (" Full" or " Charging"), set it with "A/C" icon
  local icon = theme.widget_bat_empty
  if status == " Discharging" then
    if perc > 80 then
      icon = theme.widget_bat_full
    elseif perc > 50 then
      icon = theme.widget_bat_med
    elseif perc > 20 then
      icon = theme.widget_bat_low
    else
      icon = theme.widget_bat_empty
      if perc < 9 then
	os.execute("systemctl suspend")
      end
    end
  else
    if perc == 100 then
      icon = theme.widget_ac_full
    else
      icon = theme.widget_ac
    end
  end

  -- Close the files
  fperc:close() 
  fstatus:close()

  return icon,value
end

return system
