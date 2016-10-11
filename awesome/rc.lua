---------------------------------------------------------------------------
--- My rc.lua. Inspire on it, but us it carefully (there are a lot of
--- dependencies on various linux packages and commands)
--
-- @author paoloap
-- @copyright 2016 Paolo Porcedda
-- @release 0.1
---------------------------------------------------------------------------

-- Standard libraries 
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Theming library
local beautiful = require("beautiful")
-- Notifies library
local naughty = require("naughty")
local menubar = require("menubar")

-- Layout/Widget libraries
local wibox = require("wibox")
local vicious = require("vicious")
local lain = require("lain")
local bosch = require("bosch")

-- {{{ Error managing

-- Check if awesome finds an error during startup. If yes, adopt another config
-- (the code below will be executed only in fallback

if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Error managing after startup

do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true
--    naughty.notify({ preset = naughty.config.presets.critical,
--      title = "Oops, an error happened!",
--      text = err })
    in_error = false
  end)
end

-- }}}

-- {{{ Variables

-- Load the theme
beautiful.init("/home/paoloap/.config/awesome/themes/bosch/theme.lua")

-- Default terminal, editor, launch command
terminal = "termite"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey. 'Mod4' is Windows key (also named 'Super')
modkey = "Mod4"

layouts = bosch.layoutsandtags.layouts()
tags = bosch.layoutsandtags.tags()
---- -- Layout table
---- local layouts =
---- {
----   awful.layout.suit.floating,
----   lain.layout.uselesstile,
----   lain.layout.centerfair,
---- --  lain.layout.termfair,
----   lain.layout.uselessfair,
----   lain.layout.centerwork,
----   awful.layout.suit.max,
----   awful.layout.suit.max.fullscreen
---- }
---- 
---- -- Lain: layout settings
---- lain.layout.termfair.nmaster = 3
---- lain.layout.termfair.ncol = 1
---- lain.layout.centerfair.nmaster = 3
---- lain.layout.centerfair.ncol = 1
---- lain.layout.centerwork.top_left = 0
---- lain.layout.centerwork.top_right = 1
---- lain.layout.centerwork.bottom_left = 2
---- lain.layout.centerwork.bottom_right = 3
---- 
---- -- }}}

-- {{{ Wallpapers

if beautiful.wallpaper then
  for s = 1, screen.count() do
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  end
end

-- }}}

---- -- {{{ Tags
---- 
---- tags = {}
---- 
---- tags[1] = awful.tag({"⚓", "%", "¶", "♥", "⚒", "#", "❏", "♬"  }, 1, {layouts[6], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[3]})
---- if screen.count() == 2 then
----   local fextmon = assert(io.popen("xrandr | grep ' connected ' | cut -d' ' -f1 | sed '2!d'"))
----   local extmon = fextmon:read("*l")
----   if extmon == "VGA1" then
----     tags[2] = awful.tag({"⚒", "⚓"}, 2, {layouts[2], layouts[6]})
----   else
----     tags[2] = awful.tag({"❏", "⚓"}, 2, {layouts[2], layouts[6]})
----   end
---- end
---- 
---- -- }}}

-- {{{ Menu

-- Create main menu
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

menubar.utils.terminal = terminal

-- }}}

mywibox = {}
mywibox = bosch.bwibox.get()


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
    awful.key({ modkey,           }, "Left",   function () lain.util.tag_view_nonempty(-1) end),
    awful.key({ modkey,           }, "Right",  function () lain.util.tag_view_nonempty(1) end),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    -- Spostamento tra diverse finestre dentro una tag
    -- awful.key({ modkey,           }, "j",
  awful.key({ modkey,           }, "Tab",
    function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
      -- bosch.taskbar.show(mouse.screen)
    --end,
    -- function()
      -- os.execute("(sleep 2 && echo 'bosch = require(\"bosch\"); bosch.taskbar.hide(mouse.screen)' | awesome-client) &")
      end),
  -- awful.key({ modkey,           }, "k",
  awful.key({ modkey, "Shift"   }, "Tab",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
      -- bosch.taskbar.show(mouse.screen)
    end),

  -- Mostra menu (disattivato per mancato utilizzo)
  -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

  -- Manipola il layout
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
  awful.key({ modkey,           }, "a", function ()
    awful.screen.focus_relative( 1)
      n, empty_screen = bosch.taskbar.check_skip_taskbar_screen(mouse.screen)
      if empty_screen then
	mytitlebar[mouse.screen]:set_text("")
      end
  end),


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

  awful.key({}, "Print", function () awful.util.spawn("shot 0 0 png") end),
  awful.key({ modkey, "Mod1" }, "l", function      () awful.util.spawn("dm-tool lock") end),
  awful.key({ modkey,           }, "Return", function () 
    if tags[1][1].selected then
      awful.tag.viewonly(tags[1][2])
    end
    awful.util.spawn(terminal)
  end),
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit),

  -- Altre opzioni di manipolazione layout

  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
  awful.key({ modkey,           }, "space", function ()
    awful.layout.inc(layouts,  1)
    bosch.taskbar.check_skip_taskbar_screen(mouse.screen)
  end),
  awful.key({ modkey, "Shift"   }, "space", function ()
    awful.layout.inc(layouts, -1)
    bosch.taskbar.check_skip_taskbar_screen(mouse.screen)
  end),
  awful.key({ modkey, "Control" }, "n", function ()
    local c = awful.client.restore(mouse.screen)
    bosch.taskbar.check_skip_taskbar_client(c, mouse.screen)
  end),
  awful.key({ modkey }, "\\", function()
    bosch.taskbar.toggle(mouse.screen)
  end),
  awful.key({ modkey, "Shift" }, "\\", function()
    if awful.layout.get(mouse.screen) == awful.layout.suit.max then
      layoutmax = true
      awful.layout.set(lain.layout.termfair)
    elseif awful.layout.get(mouse.screen) == lain.layout.termfair then
      layoutmax = false
      awful.layout.set(awful.layout.suit.max)
    end
  end),

  -- Menu "Super-r"
  awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
  -- awful.key({modkey }, "r", function()
  --   awful.util.spawn_with_shell( "exe=`dmenu_path | dmenu -b -nf '#888888' -nb '#000000' -sf '#ffffff' -sb '#285577'` && exec $exe")
  -- end),
  -- Menu "Lua"
  awful.key({ modkey }, "x",
    function ()
      awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval"
      )
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
    awful.util.spawn("pulseaudio-ctl down")
    local vi,vw = bosch.audio.volume()
    volumewidget:set_text(vw)
  end),
  awful.key({ }, "XF86AudioRaiseVolume", function ()
    awful.util.spawn("pulseaudio-ctl up")
    local vi,vw = bosch.audio.volume()
    volumewidget:set_text(vw)
  end),
  awful.key({ }, "XF86AudioMute", function ()
    awful.util.spawn("pulseaudio-ctl mute")
    local vi,vw = bosch.audio.volume()
    volumeicon:set_image(vi)
  end),

  -- Applicazioni
  awful.key({ modkey, "Mod1" }, "b", function () awful.util.spawn("adblim") end),
  awful.key({ modkey, "Mod1" }, "h", function () awful.util.spawn("pcmanfm") end),
  awful.key({ modkey, "Mod1" }, "n", function () awful.util.spawn("wicd-client -n") end),
  awful.key({ modkey, "Mod1" }, "e", function () awful.util.spawn("termite -e vim") end),

  -- Dynamic tagging (with LAIN)

  awful.key({ modkey, "Shift" }, "a", function () lain.util.add_tag(mypromptbox) end),
  awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag(mypromptbox) end),
  awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(1) end),  -- move to next tag
  awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(-1) end), -- move to previous tag
  awful.key({ modkey, "Shift" }, "d", function () lain.util.remove_tag() end)
)

-- Settaggi riguardanti il client

clientkeys = awful.util.table.join(
  awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
  awful.key({ modkey, "Shift"   }, "c",      function (c)
    c:kill()

  end),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey,           }, "o",      function (c)
    awful.client.movetoscreen(c, mouse.screen + 1)
    bosch.taskbar.check_skip_taskbar_client(c, mouse.screen)
  end),
--  awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
  awful.key({ modkey,           }, "n",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
      c.skip_taskbar = false
      n, empty_screen = bosch.taskbar.check_skip_taskbar_screen(mouse.screen)
      if empty_screen then
	mytitlebar[mouse.screen]:set_text("")
      end
    end),
  awful.key({ modkey,           }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c.maximized_vertical   = not c.maximized_vertical
    end
  )

)

-- Settaggi vari per spostarsi / spostare le finestre da un tag all'altro


for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = mouse.screen
	local noemptytags = {}
	for j = 1, 9 do
	  local tag = awful.tag.gettags(screen)[j]
	  if tag then
	    if awful.widget.taglist.filter.noempty(tag) then
	      table.insert(noemptytags, tag)
	    end
	  end
	end
	local seltag = noemptytags[i]
	if seltag then
          awful.tag.viewonly(seltag)
          -- check if the tag is empty. if yes, empty titlebar
	  n, empty_screen = bosch.taskbar.check_skip_taskbar_screen(mouse.screen)
	  if empty_screen then
	     mytitlebar[mouse.screen]:set_text("")
	  end
        end
      end
    ),
--    awful.key({ modkey, "Control" }, "#" .. i + 9,
--      function ()
--        local screen = mouse.screen
--        local tag = awful.tag.gettags(screen)[i]
--        if tag then
--          awful.tag.viewtoggle(tag)
--        end
--      end
--    ),
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function ()
        local tag = awful.tag.gettags(client.focus.screen)[i]
        if client.focus and tag then
          awful.client.movetotag(tag)
        end
	-- check if the screen is empty after client's repositioning. if yes, empty titlebar
	n, empty_screen = bosch.taskbar.check_skip_taskbar_screen(mouse.screen)
	if empty_screen then
	   mytitlebar[mouse.screen]:set_text("")
	end
      end
    )
--    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
--      function ()
--        local tag = awful.tag.gettags(client.focus.screen)[i]
--        if client.focus and tag then
--          awful.client.toggletag(tag)
--        end
--      end
--    )
  )
end

-- Focus / spostamento / resize finestre  con l'aiuto della modkey

clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

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
      buttons = clientbuttons
    }
  },

-- Regole per singoli client (per ora tutte disattivate)
--    { rule = { class = "MPlayer" },
--      properties = { floating = true } },
--    { rule = { class = "pinentry" },
--      properties = { floating = true } },
--    { rule = { class = "gimp" },
--      properties = { floating = true } },
--
    { rule = { name = "zsh" },
      properties = { tag = tags[1][2] }
    },
    { rule = { name = "ncmpcpp 0.7.5" },
      properties = { tag = tags[1][8] }
    },
    { rule = { class = "Vlc" },
      properties = { tag = tags[1][7] }
    },
    { rule = { name = "StartPage Search Engine" },
      properties = { tag = tags[1][1] }
    },

--      properties = { tag = tags[2][1] } },
--    { rule = { class = "Chromium" },
--      properties = { tag = tags[1][1] } },

}

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------


-- {{{ SIGNALS -------------------------------------------------------------------
-- Funzioni da eseguire all'apertura di un nuovo client

client.connect_signal("manage", function (c, startup)
  bosch.taskbar.check_skip_taskbar_client(c, mouse.screen)
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

client.connect_signal("focus", function(c)
  c.border_width = "2"
  c.border_color = beautiful.border_focus
  -- update the titlebar with new focused client's name
  mytitlebar[mouse.screen]:set_text(c.name)
end)
client.connect_signal("unfocus", function(c)
  c.border_width = "2"
  c.border_color = beautiful.border_normal
end)
client.connect_signal("unmanage", function(c)
  -- check if the screen is empty after client's closure. if yes, empty titlebar
  n, empty_screen = bosch.taskbar.check_skip_taskbar_screen(mouse.screen)
  if empty_screen then
    mytitlebar[mouse.screen]:set_text("")
  end
end)

client.connect_signal("property::name", function(c)
  -- when client changes name, check if it was focused. if yes, update titlebar
  -- (i don't know why, it doesn't work...)
  if c == client.focus then
    mytitlebar[mouse.screen]:set_text(c.name)
  end
end)

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------

