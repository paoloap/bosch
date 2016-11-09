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
    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = err })
    in_error = false
  end)
end

-- }}}

-- {{{ Variables

-- Load the theme
beautiful.init("~/.config/awesome/themes/bosch/theme.lua")

naughty.config.presets.normal.timeout          = 5
naughty.config.presets.normal.screen           = 1
naughty.config.presets.normal.position         = "top_right"
naughty.config.presets.normal.margin           = 10
naughty.config.presets.normal.gap              = "5"
naughty.config.presets.normal.ontop            = true
naughty.config.presets.normal.icon_size        = 16
naughty.config.presets.normal.fg               = beautiful.notify_fg
naughty.config.presets.normal.bg               = beautiful.notify_bg
naughty.config.presets.normal.border_color     = beautiful.notify_border
naughty.config.presets.normal.border_width     = beautiful.notify_border_width
naughty.config.presets.normal.hover_timeout    = nil
-- Default terminal, editor, launch command
terminal = "termite"
editor = "vim"
launch_in_term = terminal .. " -e "
editor_cmd = launch_in_term .. editor

-- Default modkey. 'Mod4' is Windows key (also named 'Super')
modkey = "Mod4"

layouts = bosch.layoutsandtags.layouts()
tags = bosch.layoutsandtags.tags()

-- {{{ Wallpapers

if beautiful.wallpaper then
  awful.screen.connect_for_each_screen(function(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  end)
end

-- }}}


mywibox = {}
mywibox = bosch.bwibox.init()


-- {{{ TASTIERA ------------------------------------------------------------------

-- Settaggi globali (indipendenti dal client aperto)

globalkeys = awful.util.table.join(

-- Spostamento tra diverse tag (sinistra, destra, ultima tag aperta)
    awful.key({ modkey,           }, "Left",   function () lain.util.tag_view_nonempty(-1) end),
    awful.key({ modkey,           }, "Right",  function () lain.util.tag_view_nonempty(1) end),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    -- Spostamento tra diverse finestre dentro una tag
  awful.key({ modkey,           }, "Tab",
    function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey, "Shift"   }, "Tab",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
      -- bosch.taskbar.show(mouse.screen.index)
   end),


  -- Manipola il layout
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
  awful.key({ modkey,           }, "a", function ()
    awful.screen.focus_relative( 1)
  end),


  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

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
  end),
  awful.key({ modkey, "Shift"   }, "space", function ()
    awful.layout.inc(layouts, -1)
  end),
  awful.key({ modkey, "Control" }, "n", function ()
    local c = awful.client.restore(mouse.screen)
    client.focus = c
    c:raise()
  end),
  awful.key({ modkey, "Shift" }, "n", function()
    bosch.taskbar.toggle(mouse.screen.index)
  end),
  awful.key({ modkey, }, "\\", function()
    if awful.layout.get(mouse.screen.index) == awful.layout.suit.max then
      awful.layout.set(bosch.switcher.layout())
    elseif awful.layout.get(mouse.screen.index) == bosch.switcher.layout() then
      awful.layout.set(awful.layout.suit.max)
    end
  end),

  -- Menu "Super-r"
  awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen.index]:run() end),
  -- Menu "Lua"
  awful.key({ modkey }, "x",
    function ()
      awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen.index].widget,
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

  -- MPD
  awful.key({ }, "XF86AudioPlay", function ()
    awful.util.spawn("mpc-pause")
  end),
  awful.key({ }, "XF86AudioPrev", function ()
    awful.util.spawn("mpc prev")
  end),
  awful.key({ }, "XF86AudioNext", function ()
    awful.util.spawn("mpc next")
  end),
  -- Applicazioni
  awful.key({ }, "XF86HomePage", function ()
    awful.util.spawn("brws")
  end),
  awful.key({ modkey, }, "F5", function ()
    awful.util.spawn("tiledvimb")
  end),
  awful.key({ modkey, "Mod1" }, "b", function ()
    awful.spawn("vlc", {instance = "cacca" })
  end),
  awful.key({ modkey, "Mod1" }, "h", function () awful.util.spawn("pcmanfm") end),
  awful.key({ modkey, "Mod1" }, "n", function () awful.util.spawn(launch_in_term .. "wicd-curses") end),

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
    awful.client.movetoscreen(c, mouse.screen.index + 1)
  end),
  awful.key({ modkey, "Shift"}, "o", function(c)
    awful.client.movetoscreen(c, mouse.screen.index + 1)
    awful.screen.focus_relative( 1) 
  end),
--  awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
  awful.key({ modkey,           }, "n",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
      c.skip_taskbar = false
    end),
  awful.key({ modkey,           }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c.maximized_vertical   = not c.maximized_vertical
    end
  ),
  awful.key({ modkey,           }, "<",
    function (c)
      if c.class == "Vlc" then
	if extmon == "HDMI1" then
	  awful.client.movetotag(tags[2][2],c)
	else
	  awful.client.movetotag(tags[1][7],c)
	end
      end

    end)

)

-- Settaggi vari per spostarsi / spostare le finestre da un tag all'altro


for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = mouse.screen.index
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
        end
      end
    ),
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function ()
        local tag = awful.tag.gettags(client.focus.screen.index)[i]
        if client.focus and tag then
          awful.client.movetotag(tag)
        end
      end
    )
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
      focus = awful.client.focus.filter,
      keys = clientkeys,
      buttons = clientbuttons,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen+awful.placement.under_mouse
    }
  },

    { rule = { name = "mpd-play" },
      properties = { tag = tags[1][8] }
    },
    { rule = { name = "mpd-visualizer" },
      properties = { tag = tags[1][8] }
    },
    { rule = { instance = "vimb-main" },
      properties = { tag = tags[1][1] }
    }


}

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------


-- {{{ SIGNALS -------------------------------------------------------------------
-- Funzioni da eseguire all'apertura di un nuovo client

client.connect_signal("manage", function (c, startup)
  -- Focus al passaggio del mouse
  c:connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen.index) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end

  if c.type == "normal" or c.type == "dialog" then
    bosch.switcher.init_titlebar(c)
  end
end)

client.connect_signal("focus", function(c)
  local l = awful.layout.get(c.screen.index)
  if l == bosch.switcher.layout() then c.border_color = beautiful.bg_switcher_focus
  else
    c.border_color = beautiful.border_focus
    if l == awful.layout.suit.max or c.maximized then
      c.border_color = beautiful.border_color_max
    end
  end
end)
client.connect_signal("unfocus", function(c)
  local l = awful.layout.get(c.screen.index)
  c.border_color = beautiful.border_normal
end)
client.connect_signal("property::maximized", function (c)
  if l == awful.layout.suit.max then
    c.maximized = false
  elseif c.maximized then
    c.border_color = beautiful.border_color_max
  end
end)
tag.connect_signal("property::selected", function(t)
    if t.layout == awful.layout.suit.max then
    elseif t.layout == awful.layout.suit.max.fullscreen then
      t.gap = 0
    else
      t.gap = 3
    end
  
  end)
tag.connect_signal("property::layout", function(t)
  clients = t:clients()
  local l = awful.layout.get(mouse.screen.index)
  if l == awful.layout.suit.max.fullscreen then
    t.gap = 0
  elseif l == awful.layout.suit.max then
    t.gap = 3
    for i, c in ipairs(clients) do
      awful.titlebar.hide(c)
      c.border_color = beautiful.border_color_max
    end
  elseif l == bosch.switcher.layout() then
    t.gap = 3
    for i, c in ipairs(clients) do
      awful.titlebar.show(c)
      c.border_width = beautiful.switcher_border_width
      if c == awful.client.focus.history.get(mouse.screen.index, 0) then
	c.border_color = beautiful.bg_switcher_focus
      end
      
    end
  else
    t.gap = 3
    for i, c in ipairs(clients) do
      awful.titlebar.hide(c)
      if c.maximized then
	c.border_width = beautiful.border_width_max
	c.border_color = beautiful.border_color_max
      else
	c.border_width = beautiful.border_width
      end
      if c == awful.client.focus.history.get (mouse.screen.index, 0) then
	c.border_color = beautiful.border_focus
      else
	c.border_color = beautiful.border_normal
      end
    end
  end

end)
-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------

