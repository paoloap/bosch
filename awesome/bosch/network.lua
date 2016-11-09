---------------------------------------------------------------------------
--- Network services 
---
--- NOTE: depends on wicd package (wicd-cli command)
--
-- @author paoloap
-- @copyright 2016 Paolo Porcedda
-- @release 0.1
-- @module bosch.network
---------------------------------------------------------------------------

local network = { _NAME = "bosch.network" }

--- readfile local function returns connection parameters (as boolean values)
---  NOTE: it works only if wicd-cli returns output in italian language
-- @return first true if connected
-- @return second true if connecting
-- @return third true if disconnected
-- @return fourth true if using wi-fi
-- @return fifth true if using wired connection
local function readfiles()

  -- Read wicd-cli output, put it into 3 string variables
  fwicd = assert(io.popen('wicd-cli -i', 'r'))
  firstline = fwicd:read("*l")
  secondline = fwicd:read("*l")
  thirdline = fwicd:read("*l")

  connected = nil
  connecting = nil
  disconnected = nil
  wifi = nil
  wired = nil

  -- If you want it to work for non-italian wicd-cli versions, you have to edit
  -- the following instructions
  if firstline ~= nil then
    connected = string.find(firstline,"Connesso")
    connecting = string.find(firstline,"Connessione")
    disconnected = string.find(firstline,"Non")
  end
  if secondline ~= nil then
    wifi = string.find(secondline,"senza fili")
    wired = string.find(secondline,"cablata")
  end

  return connected,connecting,disconnected,wifi,wired

end

--- network.interface function returns connection interface (as a string)
--- NOTE: it actually returns 'wlo1' for wifi interface and 'eno1' for wired interface.
--- I think it's not so difficult to generalize it.
-- @return network interface in use
function network.interface()
  connected,connecting,disconnected,wifi,wired = readfiles()
  if wifi ~= nil then
    return 'wlo1'
  elseif wired ~= nil then
    return 'eno1'
  else
    return 'wlo1'
  end
end

--- network.status function returns network icon and network status
--- NOTE: it works only if wicd-cli returns output in italian language
-- @return first an icon which represents connection status
-- @return second a string which describes connection status (interface, signal etc.)
function network.status()

  -- Initialize variables
  status = ""
  icon = theme.widget_disconnected

  connected,connecting,disconnected,wifi,wired = readfiles()

  -- 'connected' case
  if connected ~= nil  then
    i = network.interface()
    if wired ~= nil then
      icon = theme.widget_wired
      status = i
    elseif wifi ~= nil then
      netname = string.sub(thirdline,12,string.find(thirdline,"segnale") - 3)
      netperc = string.sub(thirdline,string.find(thirdline,"segnale") + 8,string.find(thirdline,"IP") - 3)
      icon = theme.widget_wifi
      status = i .. '/' .. netname .. ' (' .. netperc .. ')'
    end
  -- 'connecting' case
  elseif connecting ~= nil then
    i = network.interface()
    icon = theme.widget_disconnected
    if wifi ~= nil then
      netname = string.sub(secondline,string.find(secondline,"fili") + 6,-3)
      status = i .. '/' ..netname
    else
      status = i
    end
  -- 'disconnected' case
  elseif disconnected ~= nil then
    icon = theme.widget_disconnected
    status = "not connected"
  end

  return icon,status
end

return network
