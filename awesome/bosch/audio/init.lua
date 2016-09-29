---------------------------------------------------------------------------
--- Audio services (actually, only volume control)
---
--- NOTE: depends on pulseaudio package (pacmd command)
--
-- @author paoloap
-- @copyright 2016 Paolo Porcedda
-- @release 0.1
-- @module bosch.audio
---------------------------------------------------------------------------

local audio = { _NAME = "bosch.audio" }

--- audio.volume returns the actual volume, and an icon which represents it
-- @return first volume icon
-- @return second volume value
function audio.volume()
  local fvolume = assert(io.popen("pacmd list-sinks | sed -n -e '0,/*/d' -e '/base volume/d' -e '/volume:/p' -e '/muted:/p' | grep volume  | cut -d'/' -f2 | tr -d ' '"))
  local fstatus = assert(io.popen("pacmd list-sinks | sed -n -e '0,/*/d' -e '/base volume/d' -e '/volume:/p' -e '/muted:/p' | grep muted | cut -d' ' -f2"))
  local volume = fvolume:read("*l")
  local status = fstatus:read("*l")
  if status == "no" then
    icon = theme.widget_vol_on
  else
    icon = theme.widget_vol_off
  end

  fvolume:close()
  fstatus:close()

  return icon,volume .. " "

end

return audio
