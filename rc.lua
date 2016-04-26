
-- LIBRERIE STANDARD DA CARICARE
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- LIBRERIA WIDGET E LAYOUT
local wibox = require("wibox")
-- LIBRERIA PER LA GESTIONE DEI TEMI
local beautiful = require("beautiful")
-- LIBRERIA NOTIFICHE
local naughty = require("naughty")
local menubar = require("menubar")
-- LIBRERIA LAIN (altri layout, widget e utility)
local lain = require("lain")
-- LIBRERIA DI WIDGET VARI
local vicious = require("vicious")

-- {{{ GESTIONE ERRORI ------------------------------------------------------------

-- Controlla se awesome riscontra un errore durante lo start e in caso affermativo
-- adotta un altro config (Il codice qui sotto sarà eseguito solo in fallback)

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Gestione errori di esecuzione dopo lo start

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------


-- {{{ VARIABILI -----------------------------------------------------------------

-- Carica il tema

beautiful.init("/home/paoloap/.config/awesome/themes/bosch/theme.lua")

-- Terminale, editor, comando di lancio predefiniti

terminal = "termite"
-- editor = os.getenv("EDITOR") or "nano"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey. 'Mod4' è il tasto 'Windows' (anche detto 'Super')

modkey = "Mod4"

-- Tabella dei layout (tutti i tipi di gestione della geometria del display)

local layouts =
{
    awful.layout.suit.floating,
    lain.layout.uselesstile,
    lain.layout.centerfair,
    lain.layout.termfair,
    lain.layout.uselessfair,
    lain.layout.centerwork,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen
}

-- Lain: impostazioni dei layout
lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.centerfair.nmaster = 3
lain.layout.centerfair.ncol = 1
lain.layout.centerwork.top_left = 0
lain.layout.centerwork.top_right = 1
lain.layout.centerwork.bottom_left = 2
lain.layout.centerwork.bottom_right = 3

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------


-- {{{ SFONDI --------------------------------------------------------------------

if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------

-- {{{ TAG -----------------------------------------------------------------------

-- Definizione dei nomi delle tag e dei rispettivi layout

tags = {
   -- names  = {"www", "mail", "widi", "ssh", "soap", "chat", "file", "term", "admin"},
   -- layout = { layouts[10], layouts[10], layouts[10], layouts[2], layouts[2], layouts[10],
   --         layouts[2], layouts[2], layouts[7] }
   names = {"www", "term", "vim", "media", "social", "chat", "misc", "admin"},
   layout = { layouts[7], layouts[2], layouts[2], layouts[6], layouts[3], layouts[3],
             layouts[2], layouts[4] }
}

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------


-- {{{ MENU ----------------------------------------------------------------------

-- Crea un menu principale

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

-- Crea un launcher (da posizionare ad esempio nella barra in alto)
-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                     menu = mymainmenu })

-- Configurazione Menubar
menubar.utils.terminal = terminal -- Setta il terminale per le applicazioni che lo richiedano

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------


-- {{{ WIBOX ---------------------------------------------------------------------

-- Crea il widget separatore
separatore = wibox.widget.textbox(" |")
separatore2 = wibox.widget.textbox("| ")

-- WIDGET DOWN/UP

networktype = 'eno1'
-- netdownwidget = wibox.widget.textbox()
-- netupwidget = wibox.widget.textbox()
-- netdownwidget:set_text("")
-- netupwidget:set_text("")
-- nettimer = timer({ timeout = 1 })
-- nettimer:connect_signal("timeout,
--     function()
--         fnet = assert(io.popen('connectedto', 'r'))
--         networktype = fnet:read("*l")
--         fdown = assert(io.popen('downspeed', 'r')) 
--         downspeed = fdown:read("*l")
--         fup = assert(io.popen('upspeed', 'r'))
--         upspeed = fup:read("*l")
--         
--     end
-- )
--
--


-- WIDGET NETWORK STATUS
netstatuswidget = wibox.widget.textbox()
netstatuswidget:set_text("")
netstatusicon = wibox.widget.imagebox()
netstatusicon:set_image(theme.widget_disconnected)
netpercwidget = wibox.widget.textbox()
netpercwidget:set_text("")
netstatustimer = timer({ timeout = 3 })
netstatustimer:connect_signal("timeout",
   function()
      vicious.unregister(downwidget, keep)
      fwicd = assert(io.popen('wicd-cli -i', 'r'))
      firstline = fwicd:read("*l")
      secondline = fwicd:read("*l")
      thirdline = fwicd:read("*l")
      if firstline ~= nil then
         connected = string.find(firstline,"Connesso")
         connecting = string.find(firstline,"Connessione")
         disconnected = string.find(firstline,"Non")
      else
         connected = nil
         connecting = nil
         disconnected = nil
      end
      if secondline ~= nil then
         wifi = string.find(secondline,"senza fili")
         wired = string.find(secondline,"cablata")
      else
         wifi = nil
         wired = nil
      end
      if connected ~= nil  then
         if wired ~= nil then
            networktype = 'eno1'
            netpercwidget:set_text("")
            netstatusicon:set_image(theme.widget_wired)
            netstatuswidget:set_text(networktype)
         elseif wifi ~= nil then
            networktype = 'wlo1'
            netname = string.sub(thirdline,12,string.find(thirdline,"segnale") - 3)
            netperc = string.sub(thirdline,string.find(thirdline,"segnale") + 8,string.find(thirdline,"IP") - 3)
            netstatusicon:set_image(theme.widget_wifi)
            netstatuswidget:set_text(networktype .. '/' .. netname)
            netpercwidget:set_text(' (' .. netperc .. ')')
         end
      elseif connecting ~= nil then
         netpercwidget:set_text("")
         netstatusicon:set_image(theme.widget_disconnected)
         if wifi ~= nil then
            networktype = 'wlo1'
            netname = string.sub(secondline,string.find(secondline,"fili") + 6,-3)
            netstatuswidget:set_text(networktype .. '/' ..netname)
         else
            networktype = 'eno1'
            netstatuswidget:set_text(networktype)
         end
      elseif disconnected ~= nil then
         netstatusicon:set_image(theme.widget_disconnected)
         netstatuswidget:set_text("not connected")
         netpercwidget:set_text("")
      end
      vicious.activate(downwidget)
   end

)
netstatustimer:start()


-- WIDGET BATTERIA
-- Create the textbox that will be used to print the battery percentage and initialize it with an empty string
batterywidget = wibox.widget.textbox()
batterywidget:set_text("")
-- Create the imagebox that will be used to show battery icon and initialize it
-- with "empty battery" one
batteryicon = wibox.widget.imagebox()
batteryicon:set_image(theme.widget_bat_empty)
-- Create the timer which will allow to repeat battery status command (every 5 sec)
batterywidgettimer = timer({ timeout = 5 })
-- Initialize the timer and execute the function every 5 seconds
batterywidgettimer:connect_signal("timeout",
  function()
    -- Cut the 'acpi' output, so that it only remains the percentage number;
    -- Put it into the file 'fperc', then put its content into the numeric
    -- variable 'perc'
    fperc = assert(io.popen("acpi | cut -d' ' -f 4 | cut -d% -f 1", "r"))
    local perc = fperc:read("*number")
    -- Set 'batterywidget' textbox with the percentage
    batterywidget:set_text(perc..'%')
    -- Cut the 'acpi' output, so that it only remains the status string (which
    -- Can be " Full", " Charging" or " Discharging"; put it into the file
    -- 'fstatus', then put its content into the variable 'status'
    fstatus = assert(io.popen("acpi | cut -d: -f 2,2 | cut -d, -f 1,1", "r"))
    local status = fstatus:read("*l")
    -- if status is " Discharging", set batteryicon imagebox with the proper
    -- icon, depending charge status (0-19, 20-49, 50-79, 80-100). If the
    -- status is different (" Full" or " Charging"), set it with "A/C" icon
    if status == " Discharging" then
         if perc > 80 then
             batteryicon:set_image(theme.widget_bat_full)
         elseif perc > 50 then
             batteryicon:set_image(theme.widget_bat_med)
         elseif perc > 20 then
             batteryicon:set_image(theme.widget_bat_low)
         else
             batteryicon:set_image(theme.widget_bat_empty)
         end
    else
         batteryicon:set_image(theme.widget_ac)
    end
    -- Close the files
    fperc:close() 
    fstatus:close()
  end
)
-- Start the timer
batterywidgettimer:start()

-- Crea i widget down/up
downwidget = wibox.widget.textbox()
upwidget = wibox.widget.textbox()
-- Registra widget
vicious.register(upwidget, vicious.widgets.net,"${" .. networktype ..  " down_kb}/${" .. networktype .. " up_kb}", 2)


-- Icone dei widget down/up
dnicon = wibox.widget.imagebox()
upicon = wibox.widget.imagebox()
dnicon:set_image(theme.widget_net)
upicon:set_image(theme.widget_netup)

-- Crea il widget MPD
mpdwidget = wibox.widget.textbox()
-- Registra widget
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (mpdwidget, args)
        if args["{state}"] == "Stop" then 
            return " [silence]"
        else 
            return ' '.. args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)

-- Icone del widget MPD
musicon = wibox.widget.imagebox()
musicon:set_image(theme.widget_music)

-- Crea il widget RAM
memwidget = wibox.widget.textbox()
-- Registra widget
vicious.register(memwidget, vicious.widgets.mem, "$1% ", 13)

-- Icona del widget RAM
memicon = wibox.widget.imagebox()
memicon:set_image(theme.widget_mem)

-- Crea il widget CPU
cpuwidget = wibox.widget.textbox()
-- Registra widget
vicious.register(cpuwidget, vicious.widgets.cpu, "$1% ")

-- Icona del widget CPU
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(theme.widget_cpu)

-- Crea il widget orologio
mytextclock = awful.widget.textclock()

-- Crea un wibox per ogni schermo ed aggiungilo

mywibox = {}

mypromptbox = {}

mylayoutbox = {}

mytaglist = {}

mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
-- TASKLIST
mytasklist = {}

mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end)
)

for s = 1, screen.count() do

    -- Crea un promptbox per ogni schermo
    mypromptbox[s] = awful.widget.prompt()

    -- Crea un un widget di tipo imagebox che contiene l'icona indicante il layout attuale
    -- Ce ne serve uno per schermo.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))


    -- Crea la lista delle tag su ogni schermo
    tags[s] = awful.tag(tags.names, s, tags.layout)

    -- Crea un widget taglist che visualizzi l'elenco tag su ogni schermo
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Crea un widget con la lista dei task
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

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
    right_layout:add(musicon)
    right_layout:add(mpdwidget)
    right_layout:add(separatore)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(batteryicon)
    right_layout:add(batterywidget)
    right_layout:add(separatore)
    right_layout:add(netstatusicon)
    right_layout:add(netstatuswidget)
    right_layout:add(netpercwidget)
    right_layout:add(dnicon)
    right_layout:add(upwidget)
    right_layout:add(upicon)
    right_layout:add(separatore)
    -- if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Mettiamo tutto insiema (con la tasklist in mezzo)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)

end


-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------


-- {{{ MOUSE ---------------------------------------------------------------------

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------


-- {{{ TASTIERA ------------------------------------------------------------------

-- Settaggi globali (indipendenti dal client aperto)

globalkeys = awful.util.table.join(

-- Spostamento tra diverse tag (sinistra, destra, ultima tag aperta)
-- Disattivate per mancato utilizzo
--    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
--    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
--    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    -- Spostamento tra diverse finestre dentro una tag
    -- awful.key({ modkey,           }, "j",
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    -- awful.key({ modkey,           }, "k",
    awful.key({ modkey, "Shift"   }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Mostra menu (disattivato per mancato utilizzo)
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Manipola il layout
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey,           }, "a", function () awful.screen.focus_relative( 1) end),


    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

    -- Il vecchio spostamento da finestra attuale a ultima finestra in focus
    -- Disattivato per mancato utilizzo
    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --            if client.focus then
    --                client.focus:raise()
    --            end
    --        end
    --     ),

    -- Programmi

    awful.key({ modkey, "Control" }, "l", function      () awful.util.spawn("dm-tool lock") end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    -- Altre opzioni di manipolazione layout

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Menu "Super-r"
--    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
awful.key({modkey }, "r", function()
  awful.util.spawn_with_shell( "exe=`dmenu_path | dmenu -b -nf '#888888' -nb '#000000' -sf '#ffffff' -sb '#285577'` && exec $exe")
end),
    -- Menu "Lua"
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menu "Super-p"
    awful.key({ modkey }, "p", function() menubar.show() end),

    -- Luminosità
    awful.key({ }, "XF86MonBrightnessDown", function ()
        awful.util.spawn("xbacklight -dec 15") end),
    awful.key({ }, "XF86MonBrightnessUp", function ()
        awful.util.spawn("xbacklight -inc 15") end),

    -- Controllo volume
   awful.key({ }, "XF86AudioLowerVolume", function ()
        awful.util.spawn("pulseaudio-ctl down") end),
   awful.key({ }, "XF86AudioRaiseVolume", function ()
        awful.util.spawn("pulseaudio-ctl up") end),
   awful.key({ }, "XF86AudioMute", function ()
        awful.util.spawn("pulseaudio-ctl mute") end),

    
    -- Applicazioni
    awful.key({ modkey, "Mod1" }, "v", function () awful.util.spawn("vlc") end),
    awful.key({ modkey, "Mod1" }, "f", function () awful.util.spawn("firefox") end),
    awful.key({ modkey, "Mod1" }, "h", function () awful.util.spawn("pcmanfm") end),
    awful.key({ modkey, "Mod1" }, "m", function () awful.util.spawn("player") end),
    awful.key({ modkey, "Mod1" }, "n", function () awful.util.spawn("wicd-client -n") end),
    awful.key({ modkey, "Mod1" }, "e", function () awful.util.spawn("termite -e vim") end)

   
)

-- Settaggi riguardanti il client

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Settaggi vari per spostarsi / spostare le finestre da un tag all'altro

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

-- Focus / spostamento / resize finestre  con l'aiuto della modkey

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Probabilmente per attivare tutte le combinazioni da tastiera
root.keys(globalkeys)

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------


-- {{{ REGOLE --------------------------------------------------------------------

awful.rules.rules = {
    -- Regole valide per tutti i client
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },

-- Regole per singoli client (per ora tutte disattivate)
--    { rule = { class = "MPlayer" },
--      properties = { floating = true } },
--    { rule = { class = "pinentry" },
--      properties = { floating = true } },
--    { rule = { class = "gimp" },
--      properties = { floating = true } },
--    { rule = { class = "Firefox" },
--      properties = { tag = tags[1][1] } },
--    { rule = { class = "VirtualBox" },
--      properties = { tag = tags[2][1] } },
--    { rule = { class = "Chromium" },
--      properties = { tag = tags[1][1] } },

}

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------


-- {{{ SIGNALS -------------------------------------------------------------------
-- Funzioni da eseguire all'apertura di un nuovo client

client.connect_signal("manage", function (c, startup)
    -- Focus al passaggio del mouse
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    -- DISATTIVA TUTTE LE CAZZO DI TITLEBAR
    local titlebars_enabled = false

    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- pulsanti titlebar (in caso venisse attivata su qualche client)
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets allineati a sinistra nella titlebar
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets allineati a destra nella titlebar
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- Titolo titlebar (in mezzo)
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Metti insieme tutto
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------

