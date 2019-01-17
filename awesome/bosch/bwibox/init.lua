---------------------------------------------------------------------------
--- BOSCH - bwibox init.lua
--- Bosch top wibox initialization file
--- To do: Comments
-- Released under GPL v3
-- @author schuppenflektor
-- @copyright 2016-2018 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.7
---------------------------------------------------------------------------

local bwibox =
{
  _NAME = "bosch.bwibox",
  network = require("bosch.bwibox.network"),
  system = require("bosch.bwibox.system"),
  audio = require("bosch.bwibox.audio"),
  various = require("bosch.bwibox.various"),
}

local awful = require ("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
local tricks = require("bosch.utils.tricks")

require("bosch.config")

beautiful.init(config.theme)




function bwibox.init()
   local widgetTimers = { }
   -- All widget we want to show in bwibox
   local separator = wibox.widget.textbox("\\ ")
   --batteryicon, batterystatus = bwibox.system.battery()
--   local neticon, netstatus = bwibox.network.status()
   local traffwset, traffic_timer = bwibox.network.traffic(1)
   local conwset, connection_timer = bwibox.network.wicd(3)
   local pulsewset, pulse_timer = bwibox.audio.pulse(1)
   local mwset, mpd_timer = bwibox.audio.mpd(5)
   local memicon, memwidget = bwibox.system.memory()
   local cpuicon, cpuwidget = bwibox.system.cpu()
   local thermicon, thermwidget = bwibox.system.thermal()
   --mailicon, mailwidget = bwibox.various.mail()
   local capsicon = bwibox.various.capslock()
   local textclock = awful.widget.textclock()
   local main = {}
   local taglist = {}
   local promptbox = {}
   local titlebar = {}
   local layoutbox = {}
   -- Draw a bwibox for every screen, basing on theme options
   for s = 1, screen.count() do
     main[s] = awful.wibar(
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
   
   awful.util.spawn("killall bwibox.sh; exec " .. config.scripts .. "/bwibox.sh")
  -- Elements which are potentially different in every screen
  -- Variables need to be initialized because the are arrays
  -- (i.e. mywibox[1] is different from mywibox[2]
  -- For every bwibox, put the desired widget in the choosen order and position
  local allWidgets = {} 
  widgetTimers.volume = pulse_timer
  widgetTimers.mpd = mpd_timer
  widgetTimers.connection = connection_timer
  widgetTimers.traffic = traffic_timer
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
    -- naughty.notify({text = widgetTimers.traffic.timeout ..""})

    -- Volume widgets
--    for i=1,#volumewset do
--       if i ~= firstvw then
--          right_layout:add(volumewset[i])
--       end
--    end
      for k, w in pairs(config.audio.sinks) do
         right_layout:add(pulsewset[k .. "_pic"])
         right_layout:add(pulsewset[k .. "_txt"])
      end
    --right_layout:add(volumeicon)
    --right_layout:add(volumewidget)
    right_layout:add(mwset.icon)
    right_layout:add(mwset.text)
    right_layout:add(separator)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(memicon)
    right_layout:add(memwidget)
--    right_layout:add(batteryicon)
--    right_layout:add(batterystatus)
    right_layout:add(thermicon)
    right_layout:add(thermwidget)
    right_layout:add(separator)
    right_layout:add(conwset.icon)
    right_layout:add(conwset.text)
    right_layout:add(traffwset.dlicon)
    right_layout:add(traffwset.text)
    right_layout:add(traffwset.ulicon)

    right_layout:add(separator)
    --if s == 1 then right_layout:add(wibox.widget.systray()) end
--    right_layout:add(mailicon)
    right_layout:add(capsicon)
    right_layout:add(separator)
    right_layout:add(textclock)
    right_layout:add(layoutbox[s])
  
    -- Mettiamo tutto insiema (con la tasklist in mezzo)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(titlebar[s])
    layout:set_right(right_layout)
    main[s]:set_widget(layout)
    allWidgets[s] = {
       separator = separator;
       taglist = taglist;
       titlebar = titlebar[s];
       promptbox = promptbox[s];
       volume = pulsewset;
       mpd = mpdwidget;
       cpu = { icon = cpuicon; text = cpuwidget };
       memory = { icon = memicon; text = memwidget };
       thermal = { icon = thermicon; text = thermwidget };
       net = { icon = neticon; text = netwidget };
       traffic = traffwset;
       clock = textclock;
       layoutbox = layoutbox[s]
    }
  end
--              naughty.notify({text = allWidgets[1].traffic[2].text })

  return main, tricks.readonlytable(widgetTimers), tricks.readonlytable(allWidgets)

end

return bwibox
