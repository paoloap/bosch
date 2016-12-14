local keys = { _NAME = "bosch.keys" }

local awful = require("awful")
local lain = require("lain")
local naughty = require("naughty")


-- Global settings

local globalkeys = awful.util.table.join(

  -- TILING-RELATED KEY BINDINGS
  -- Move tags (deprecated)
  awful.key({ modkey, "Control" }, "Left", function () lain.util.move_tag(-1) end),
  awful.key({ modkey, "Control" }, "Right", function () lain.util.move_tag(1) end),
  -- Navigate between tags
  awful.key({ modkey, }, "Left",   function () lain.util.tag_view_nonempty(-1) end),
  awful.key({ modkey, }, "Right",  function () lain.util.tag_view_nonempty(1) end),
  awful.key({ modkey, }, "Escape", awful.tag.history.restore),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
  -- Change client focus
  awful.key({ modkey, }, "Tab",
    function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey, "Shift" }, "Tab",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
   end),
  awful.key({ modkey, }, "a", function ()
    awful.screen.focus_relative( 1)
  end),
  -- Move clients into selected tag
  awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx( -1)    end),
  awful.key({ modkey, "Control" }, "n", function ()
    local c = awful.client.restore(mouse.screen)
    client.focus = c
    c:raise()
  end),
  -- Change selected layout geometry
  awful.key({ modkey, }, "l", function () awful.tag.incmwfact( 0.05) end),
  awful.key({ modkey, }, "h", function () awful.tag.incmwfact(-0.05) end),
  awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster( 1) end),
  awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end),
  awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1) end),
  awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end),
  -- Change layout
  awful.key({ modkey, }, "space", function ()
    awful.layout.inc(1, mouse.screen, layouts)
  end),
  awful.key({ modkey, "Shift" }, "space", function ()
    awful.layout.inc(-1, mouse.screen, layouts)
  end),
  -- Show minimized clients list
  awful.key({ modkey, "Shift" }, "n", function()
    bosch.taskbar.toggle(mouse.screen.index)
  end),
  -- Show switcher
  awful.key({ modkey, }, "\\", function()
    if awful.layout.get(mouse.screen.index) == awful.layout.suit.max then
      awful.layout.set(bosch.switcher.layout())
    elseif awful.layout.get(mouse.screen.index) == bosch.switcher.layout() then
      awful.layout.set(awful.layout.suit.max)
    end
  end),

  -- SYSTEM-RELATED KEY BINDINGS
  -- Awesome stuff
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift" }, "q", awesome.quit),
  awful.key({ modkey }, "r", function ()
    promptbox[mouse.screen.index]:run()
  end),                                  
  awful.key({ modkey }, "x", function ()
    awful.prompt.run({ prompt = "Run Lua code: " },
      promptbox[mouse.screen.index].widget,
      awful.util.eval, nil,
      awful.util.getdir("cache") .. "/history_eval"
    )
  end),
  awful.key({ modkey }, "p", function()
    menubar.show()
  end),
  -- Brightness
  awful.key({}, "XF86MonBrightnessDown", function ()
    awful.util.spawn(config.command.brightdown) end),
  awful.key({}, "XF86MonBrightnessUp", function ()
    awful.util.spawn(config.command.brightup) end),
  -- Volume control
  awful.key({}, "XF86AudioLowerVolume", function ()
    awful.util.spawn(config.command.volumeup)
  end),
  awful.key({}, "XF86AudioRaiseVolume", function ()
    awful.util.spawn(config.command.volumedown)
  end),
  awful.key({}, "XF86AudioMute", function ()
    awful.util.spawn(config.command.volumetoggle)
  end),
  -- MPD
  awful.key({}, "XF86AudioPlay", function ()
    awful.util.spawn(config.command.mpdplay)
  end),
  awful.key({}, "XF86AudioPrev", function ()
    awful.util.spawn(config.command.mpdprev)
  end),
  awful.key({}, "XF86AudioNext", function ()
    awful.util.spawn(config.command.mpdnext)
  end),
  -- Take screenshot
  awful.key({}, "Print", function ()
    awful.util.spawn(config.command.screenshot)
  end),
  -- Lock screen
  awful.key({ modkey, "Mod1" }, "l", function ()
    awful.util.spawn(config.command.lock)
  end),

  -- APP LAUNCH KEY BINDINGS
  awful.key({ modkey, }, "Return", function () 
    if tags[1][1].selected then                      -- VEDI MEGLIO
      awful.tag.viewonly(tags[1][2])
    end
    awful.util.spawn(config.terminal)
  end),
  awful.key({}, "XF86HomePage", function ()
    awful.util.spawn(config.program.maxbrowser)
  end),
  awful.key({ modkey, }, "F5", function ()
    awful.util.spawn(config.program.tiledbrowser)
  end),
  awful.key({ modkey, "Mod1" }, "h", function ()
    awful.util.spawn(config.program.filemanager)
  end),
  awful.key({ modkey, "Mod1" }, "w", function ()
    awful.util.spawn(config.program.writer)
  end),
  awful.key({ modkey, "Mod1" }, "n", function ()
    awful.util.spawn(config.program.connection)
  end),
  awful.key({ modkey, "Mod1" }, "t", function ()
    awful.util.spawn(config.program.torrent)
  end)
)

-- <mod>+<num> keybindings 
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = mouse.screen.index
	local noemptytags = {}
	for j = 1, 9 do
	  local tag = tags[screen][j]
	  if tag then
	    if awful.widget.taglist.filter.noempty(tag) then
	      table.insert(noemptytags, tag)
	    end
	  end
	end
	local seltag = noemptytags[i]
	if seltag then
	  seltag:view_only()
        end
      end
    )
  )
end

-- CLIENT-RELATED KEY BINDINGS

local clientkeys = awful.util.table.join(
  -- Move client to ta
  awful.key({ modkey, "Shift" }, "Left", function (c)
    c:move_to_tag(tags[c.screen.index][c.screen.selected_tag.index -1])
    awful.tag.viewprev(mouse.screen.index)
  end),
  awful.key({ modkey, "Shift" }, "Right", function (c)
    c:move_to_tag(tags[c.screen.index][c.screen.selected_tag.index +1])
    awful.tag.viewnext(mouse.screen.index)
  end),
  awful.key({ modkey, }, "z",
    function (c)
      local itsTag = bosch.tiling.getDefaultClientsTag(c)
      awful.client.movetotag(itsTag,c)
    end),
  -- Toggle fullscreen
  awful.key({ modkey, }, "f", function (c)
    c.fullscreen = not c.fullscreen
  end),
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
  )

)


-- Focus / spostamento / resize finestre  con l'aiuto della modkey

local clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

function keys.global()
  naughty.notify({text = "AHAHAHOHOHOHOH. ahahah ahhaah ah. ah."})
  return clientkeys
end

return keys

-- }}} ---------------------------------------------------------------------------
----------------------------------------------------------------------------------

