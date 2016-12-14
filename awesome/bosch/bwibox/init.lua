---------------------------------------------------------------------------
--- BOSCH - bwibox init.lua
--- Bosch top wibox initialization file
--- To do: Comments
-- Released under GPL v3
-- @author schuppenflektor
-- @copyright 2016 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.6
---------------------------------------------------------------------------

local bwibox =
{
  _NAME = "bosch.bwibox",
  network = require("bosch.bwibox.network"),
  system = require("bosch.bwibox.system"),
  audio = require("bosch.bwibox.audio"),
  various = require("bosch.bwibox.various")
}

local awful = require ("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
require("bosch.config")

beautiful.init(config.theme)

separator = wibox.widget.textbox(" \\ ")
batteryicon, batterystatus = bwibox.system.battery()
neticon, netstatus = bwibox.network.status()
dnicon, upicon, trafficwidget =bwibox.network.traffic()
volumeicon, volumewidget  = bwibox.audio.volume()
mpdwidget = bwibox.audio.mpd()
memicon, memwidget = bwibox.system.memory()
cpuicon, cpuwidget = bwibox.system.cpu()
mailicon, mailwidget = bwibox.various.mail()
textclock = awful.widget.textclock()
main = {}
taglist = {}
promptbox = {}
titlebar = {}
layoutbox = {}

for s = 1, screen.count() do
  main[s] = awful.wibox(
                      {
                        position = "top",
                        height = 20,
                        screen = s,
                        bg = beautiful.bg_bwibox,
                        fg = beautiful.fg_bwibox
                      })

  taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, nil, 
                      {
                        fg_focus = beautiful.fg_bwibox_seltag,
                        bg_focus = beautiful.bg_bwibox_seltag,
                        fg_urgent = beautiful.fg_bwibox_urgent
                      })

  promptbox[s] = awful.widget.prompt()
  titlebar[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, nil,
                      {
                        bg_focus = beautiful.bg_bwibox,
                        fg_focus = beautiful.fg_bwibox
                      })
  layoutbox[s] = awful.widget.layoutbox()
end

function bwibox.init()
  awful.util.spawn("killall bwibox.sh; exec " .. config.scripts .. "/bwibox.sh")
  -- Elements wchich are potentially different in every screen
  -- Variables need to be initialized because the are arrays
  -- (i.e. mywibox[1] is different from mywibox[2]
    
  for s = 1, screen.count() do
    -- Create Layout Box
      -- Widget allineati a sinistra
    local left_layout = wibox.layout.fixed.horizontal()
    -- left_layout:add(mylauncher)
    left_layout:add(taglist[s])
    left_layout:add(separator)
    left_layout:add(promptbox[s])
  
    -- Widget allineati a destra
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(separator)
    right_layout:add(volumeicon)
    right_layout:add(volumewidget)
    right_layout:add(mpdwidget)
    right_layout:add(separator)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(batteryicon)
    right_layout:add(batterystatus)
    right_layout:add(separator)
    right_layout:add(neticon)
    right_layout:add(netstatus)
    right_layout:add(dnicon)
    right_layout:add(trafficwidget)
    right_layout:add(upicon)
    right_layout:add(separator)
    --if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mailicon)
    right_layout:add(mailwidget)
    right_layout:add(separator)
    right_layout:add(textclock)
    right_layout:add(layoutbox[s])
  
    -- Mettiamo tutto insiema (con la tasklist in mezzo)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(titlebar[s])
    layout:set_right(right_layout)
    main[s]:set_widget(layout)
  
  end
  return main

end

return bwibox
