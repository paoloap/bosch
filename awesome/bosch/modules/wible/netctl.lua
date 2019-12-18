local netctl =
{
   _NAME = "bosch.modules.wible.netctl",
   new  = function(custom_conf)
      bosch.modules.wible("netctl", custom_conf)
   end
}

local wibox = { widget = wibox.widget }

setmetatable
(
   netctl,                              -- this is the table
   {                                   -- this is the metatable
      __call = function(cls, ...)
         return cls.new(...)
      end,
   }
)




beautiful.init(conf.dir.core .. "theme.lua")

netctl.conf              = 
{
   refresh_time         = 3,
   view                 = 
   {
      disconnected      = beautiful.network_disconnected,
      connecting        = beautiful.network_connecting,
      wifi              = beautiful.network_wifi,
      ethernet          = beautiful.network_ethernet,
      disc_format       = "disconnected",
      wifi_c_format     = "[i]/[e]",
      ether_c_format    = "[i]/connecting",
      wifi_cc_format    = "[i]/[e] ([q]%)",
      ether_cc_format   = "[i]/connected"
   },
}

-- requires pacmd command installed
netctl.command =
[[
   netctl list | grep -e ^\* -e ^\+ | tr " " "\>" | sed -r 's/^(..[^-]*)-/\1>/'
]]


function netctl.create(nconf)
   local view = nconf.view
   return
   {
      wibox.widget.imagebox(view.disconnected),
      wibox.widget.textbox(view.disc_format)
   }
end

function netctl.exec(output, nconf, widgets)
-- Expected output variable:
-- [*|+]+>[interface]>[essid]

   local wifi_q = function(interface)
      local quality
      local f = assert(io.open("/proc/net/wireless", "r"))
      local content = f:read("*all*")
      local pnw_strings = tricks.rows(content)
      for i,s in ipairs(pnw_strings) do
         if string.match(s, interface) then
            local primo_blocco = tricks.split(s, "%.")[1]
            local secondo_blocco = tricks.split(primo_blocco," ")
            local posizione = tricks.table_size(secondo_blocco)
            quality = secondo_blocco[posizione]
         end
      end
      f:close()
      return quality
   end

   local extract_text = function(args)
      local pattern = args.pattern
      for k, v in pairs(args) do
         if k ~= "pattern" then
            pattern = pattern:gsub("%[" .. k .. "%]", v)
         end
      end
      return pattern
   end

   local output_strings = tricks.rows(output)
   local connected, interface, ssid, quality
   local pic = nconf.view.disconnected
   local text_pattern = nconf.view.disc_format
   if output_strings[1] then
      local conn_data = tricks.split(output_strings[1], ">")
      connected = conn_data[1] == "*"
      interface = conn_data[2]
      ssid = conn_data[3] or ""
      local ni = string.sub(interface, 1, 1)
      if connected then
         if ni == "w" then
            pic = nconf.view.wifi
            text_pattern = nconf.view.wifi_cc_format
            quality = wifi_q(interface)
         else
            pic = nconf.view.ethernet
            text_pattern = nconf.view.ether_cc_format
         end
      else
         if ni == "w" then
            text_pattern = nconf.view.wifi_c_format
         else
            text_pattern = nconf.view.ether_c_format
         end
         pic = nconf.view.connecting
      end
   end
   local text = extract_text
   (
      {
         pattern = text_pattern,
         i = interface,
         e = ssid,
         q = quality
      }
   )
   --naughty.notify({text = netctl.conf.view.wifi })
   widgets[1]:set_image(pic)
   widgets[2]:set_text(text)

end

return netctl
