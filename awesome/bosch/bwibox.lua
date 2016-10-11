
local bwibox = { _NAME = "bosch.bwibox"}

local awful = require ("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local lain = require("lain")
local vicious = require("vicious")
local system = require("bosch.system")
local audio = require("bosch.audio")
local network = require("bosch.network")

function bwibox.battery()
  local batterytimer = timer({ timeout = 5 })
  local batteryicon = wibox.widget.imagebox()
  local batterystatus = wibox.widget.textbox()
  batterytimer:connect_signal("timeout",function()
    bi,bs = system.battery()
    batteryicon:set_image(bi)
    batterystatus:set_text(bs)
  end)
  batterytimer:start()
  return batteryicon, batterystatus, batterytimer
end

function bwibox.network()
  local netstatustimer = timer({ timeout = 3 })
  local neticon = wibox.widget.imagebox()
  local netstatus = wibox.widget.textbox()
  netstatustimer:connect_signal("timeout",function()
    ni,ns = network.status()
    neticon:set_image(ni)
    netstatus:set_text(ns)
  end)
  netstatustimer:start()
  return neticon, netstatus, netstatustimer
end

function bwibox.traffic()
  local netinterface = network.interface()
  local downwidget = wibox.widget.textbox()
  local upwidget = wibox.widget.textbox()
  vicious.register(upwidget, vicious.widgets.net,"${" .. netinterface ..  " down_kb}/${" .. netinterface .. " up_kb}", 2)
  local dnicon = wibox.widget.imagebox()
  local upicon = wibox.widget.imagebox()
  dnicon:set_image(theme.widget_net)
  upicon:set_image(theme.widget_netup)
  return dnicon, upicon, downwidget, upwidget
end

function bwibox.separators()
  local separatore = wibox.widget.textbox(" |")
  local separatore2 = wibox.widget.textbox("| ")
  return separatore, separatore2
end

function bwibox.volume()
  local volumetimer = timer({ timeout = 2 })
  local volumewidget = wibox.widget.textbox()
  local volumeicon = wibox.widget.imagebox()
  volumetimer:connect_signal("timeout", function()
    vi,vw = audio.volume()
    volumeicon:set_image(vi)
    volumewidget:set_text(vw)
  end)
  volumetimer:start()
  return volumeicon, volumewidget, volumetimer
end

function bwibox.mpd()
  local mpdwidget = wibox.widget.textbox()
  vicious.register(mpdwidget, vicious.widgets.mpd,
    function (mpdwidget, args)
      if args["{state}"] == "Stop" then 
        return ""
      else
        return "♬ " .. args["{Artist}"]..'/'.. args["{Title}"]
      end
    end, 7)
  return mpdwidget
end

function bwibox.memory()
  local memwidget = wibox.widget.textbox()
  vicious.register(memwidget, vicious.widgets.mem, "$1% ", 13)
  local memicon = wibox.widget.imagebox()
  memicon:set_image(theme.widget_mem)
  return memicon, memwidget
end

function bwibox.cpu()
  local cpuwidget = wibox.widget.textbox()
  vicious.register(cpuwidget, vicious.widgets.cpu, "$1% ")
  local cpuicon = wibox.widget.imagebox()
  cpuicon:set_image(theme.widget_cpu)
  return cpuicon, cpuwidget
end

function bwibox.get()

  -- Fixed elements (which are the same in every screen
  separatore, separatore2 = bwibox.separators()
  batteryicon, batterystatus, batterytimer = bwibox.battery()
  neticon, netstatus, netstatustimer = bwibox.network()
  dnicon, upicon, downwidget, upwidget = bwibox.traffic()
  volumeicon, volumewidget, volumetimer = bwibox.volume()
  mpdwidget = bwibox.mpd()
  memicon, memwidget = bwibox.memory()
  cpuicon, cpuwidget = bwibox.cpu()
  mytextclock = awful.widget.textclock()
  
  -- Elements wchich are potentially different in every screen
  -- Variables need to be initializzate because the are arrays
  -- (i.e. mywibox[1] is different from mywibox[2]
  mywibox = {}
  my2ndwibox = {}
  mypromptbox = {}
  mylayoutbox = {}
  mytitlebar = {}
  mytaglist = {}
    
  for s = 1, screen.count() do
    mypromptbox[s] = awful.widget.prompt()
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, mytaglist.buttons)
  --   mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    mytitlebar[s] = wibox.widget.textbox()
  
  -- Crea la wibox vera e propria
    mywibox[s] = awful.wibox({ position = "top", height = 20, screen = s })
  
      -- Widget allineati a sinistra
    local left_layout = wibox.layout.fixed.horizontal()
    -- left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(separatore2)
    left_layout:add(mypromptbox[s])
  
    -- Widget allineati a destra
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(separatore)
    right_layout:add(volumeicon)
    right_layout:add(volumewidget)
    right_layout:add(mpdwidget)
    right_layout:add(separatore)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(batteryicon)
    right_layout:add(batterystatus)
    right_layout:add(separatore)
    right_layout:add(neticon)
    right_layout:add(netstatus)
    right_layout:add(dnicon)
    right_layout:add(upwidget)
    right_layout:add(upicon)
    right_layout:add(separatore)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])
  
    -- Mettiamo tutto insiema (con la tasklist in mezzo)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytitlebar[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)
  
  end

  return mywibox

end

return bwibox
