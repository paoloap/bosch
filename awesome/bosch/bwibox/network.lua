----------------------------------------------------------------------------
--- BOSCH - network.lua
--- Network and traffic widgets for Bosch top wibox
--- To do: Correct comments
-- @author schuppenflektor
-- @copyright 2016-2018 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.7
-- @module bosch.bwibox.network
----------------------------------------------------------------------------

local network = { _NAME = "bosch.bwibox.network" }

local wibox = require("wibox")
local awful = require ("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local data = require("bosch.utils.data")
local tricks = require("bosch.utils.tricks")

--- network.status returns connection status widgets
-- @return first a set of two widget (an imagebox and a text_box)
-- @return second the timer which controls widgets refresh
function network.wicd(refresh)

   local DISC_PIC       = beautiful.network_disconnected
   local CONN_PIC       = beautiful.network_connecting
   local WIFI_PIC       = beautiful.network_wifi
   local WIRE_PIC       = beautiful.network_wired
   local bscript        = "wicd-cli -i"

   -- Constraints which depend on wicd-cli language (Italian in this case)
   local DISCONNECTED   = "Non connesso"
   local CONN_TO_WIFI   = "Connessione in corso alla rete senza fili"
   local CONN_TO_WIRED  = "Connessione in corso ad una rete con fili"
   local CONNECTED      = "Connesso a "
   local SIGNAL         = "segnale "

   local cwidgets       =
   {
      icon              = wibox.widget.imagebox(DISC_PIC);
      text              = wibox.widget.textbox("disconnected")
   }
   local ctimer         = timer({ timeout = refresh })

   ctimer:connect_signal(
      "timeout",
      function ()
         awful.spawn.easy_async_with_shell
         (
            bscript,
            function (output)
               local output_strings = tricks.split(output, "\n")
               if string.match(output_strings[1], DISCONNECTED) then
                  cwidgets.icon:set_image(DISC_PIC)
                  cwidgets.text:set_text("disconnected")
               elseif string.match(output_strings[2], CONN_TO_WIFI) then
                  local interface = config.network.interfaces["wifi"]
                  local essid = tricks.split(output_strings[2], '"')
                  cwidgets.icon:set_image(CONN_PIC)
                  cwidgets.text:set_text(interface .. "/" .. essid)
               elseif string.match(output_strings[2], CONN_TO_WIRED) then
                  local interface = config.network.interfaces["wired"]
                  cwidgets.icon:set_image(CONN_PIC)
                  cwidgets.text:set_text(interface)
               elseif string.match(output_strings[3], CONNECTED) then
                  if string.match(output_strings[3], SIGNAL) then
                     local interface = config.network.interfaces["wifi"]
                     local essid = tricks.split(tricks.split(output_strings[3], CONNECTED)[2], ",")[1]
                     local signal = tricks.split(tricks.split(output_strings[3], SIGNAL)[2], " ")[1]
                     cwidgets.icon:set_image(WIFI_PIC)
                     cwidgets.text:set_text(interface .. "/" .. essid .. " (" .. signal .. ")")
                  else
                     local interface = config.network.interfaces["wired"]
                     cwidgets.icon:set_image(WIRED_PIC)
                     cwidgets.text:set_text(interface .. "/connected")
                  end
               else
                  -- Situazione non prevista
                  cwidgets.icon:set_image(beautiful.widget_voi)
                  cwidgets.text:set_text("error during wicd widget data get")
               end
            end
         )
      end
   )
   ctimer:start()
   return cwidgets, ctimer
end

function network.traffic(refresh)
   
   local UL_STRESS      = 100
   local DL_STRESS      = 500
   local DL_PIC         = beautiful.network_download
   local DL_STRESS_PIC  = beautiful.network_download_stress
   local UL_PIC         = beautiful.network_upload
   local UL_STRESS_PIC  = beautiful.network_upload_stress

   local bscript        =
      "interface=`ifconfig | grep -B1 broadcast | cut -d':' -f1`; " ..
      "grep $interface /proc/net/dev | awk '{print $2,$10}' >> " .. config.tmpfiles.traffic .."; "

   local twidgets =
   {
      text          = wibox.widget.textbox("0,0/0,0");
      dlicon        = wibox.widget.imagebox(DL_PIC);
      ulicon        = wibox.widget.imagebox(UL_PIC)
   }
   local ttimer                 = timer({ timeout = refresh })

   ttimer:connect_signal(
      "timeout",
      function()
         awful.spawn.easy_async_with_shell
         (
            bscript,
            function ()
               awful.spawn.easy_async_with_shell
               (
                  "cat " .. config.tmpfiles.traffic,
                  function (output)
                     local prev, actual = tricks.split(output, "\n")[1],tricks.split(output, "\n")[2]
                     local d1, u1 = tricks.split(prev, " ")[1], tricks.split(prev," ")[2]
                     local d2, u2 = tricks.split(actual, " ")[1], tricks.split(actual," ")[2]
                     local dnum = math.floor((tonumber(d2) - tonumber(d1)) / 1024 * 10) / 10
                     local unum = math.floor((tonumber(u2) - tonumber(u1)) / 1024 * 10) / 10
                     local downloadrate = (dnum .. ""):gsub("%.",",")
                     local uploadrate = (unum .. ""):gsub("%.",",")
                     local text = downloadrate .. "/" .. uploadrate
                     for s in screen do
                        -- wset should contain traffic widgets in the order "download icon",
         	        -- "text widget", "upload icon"
                        local wset = wibarswidgets[s.index].traffic

--                        naughty.notify({text = text})
                        wset.text:set_text(text)
                        if dnum > DL_STRESS then
                           --wset.dlicon:set_image(DL_STRESS_PIC)
                           twidgets.dlicon:set_image(DL_STRESS_PIC)
                        else
                           wset.dlicon:set_image(DL_PIC)
                        end
                        if unum > UL_STRESS then
                           wset.ulicon:set_image(UL_STRESS_PIC)
                        else
                           wset.ulicon:set_image(UL_PIC)
                        end
         
                     end
      
                  end
               )
               refresh_command =
                  "tail -1 " ..config.tmpfiles.traffic.. " > " ..config.tmpfiles.traffic.. "_tmp; " .. 
                  "mv " ..config.tmpfiles.traffic.. "_tmp " .. config.tmpfiles.traffic
               
               awful.spawn.with_shell(refresh_command)
            end
         )
      end
   )
   ttimer:start()
--     naughty.notify({text = ttimer.timeout .. ""})
   return twidgets, ttimer
   
end

return network
