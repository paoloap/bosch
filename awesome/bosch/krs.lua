---------------------------------------------------------------------------
--- BOSCH - krc.lua
--- Keybindings, Rules and Signals
-- Released under GPL v3
-- @author schuppenflektor
-- @copyright 2016-2018 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.7
---------------------------------------------------------------------------

local krs = { _NAME = "bosch.krs" }

local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local beautiful = require("beautiful")
local lain = require("lain")
local naughty = require("naughty")
require("bosch.config")
local tiling = require("bosch.tiling")
local switcher = require("bosch.switcher")

local modkey = config.modkey

local layouts = tiling.layouts

-- {{{ INPUT --------------------------------------------------------------------

-- Global settings

globalkeys = {}
globalkeys = awful.util.table.join(

-- Restart/Quit AwesomeWM
	awful.key(
		{	modkey,	"Control"	},	"r",
		awesome.restart
	),

	awful.key(
		{	modkey,	"Control"	},	"q",
		awesome.quit
	),

-- Move between active tags
-- Left
	awful.key(
		{	modkey				},	"a",
		function()
		  lain.util.tag_view_nonempty(-1)
		end
	),
-- Right
	awful.key(
		{	modkey,				},	"s",
		function()
			lain.util.tag_view_nonempty(1)
		end
	),
-- Last opened tag
	awful.key(
		{	modkey,				},	"Escape",
		function()
		  awful.tag.history.restore()
		end
	),
-- Other screen
	awful.key(
		{	modkey,				},	"d",
		function()
		  awful.screen.focus_relative(1)
		end
	),

-- Change focus in actual tag
	awful.key(
		{	modkey,				},	"Tab",
		function ()
			awful.client.focus.byidx( 1)
			if client.focus then
				client.focus:raise()
			end
        end),
	awful.key(
		{	modkey,	"Shift"		},	"Tab",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then
				client.focus:raise()
			end
			-- bosch.taskbar.show(mouse.screen.index)
        end
	),

-- Go to "urgent" (actually deactivated)
-- awful.key({ modkey, "Shift" }, "Escape", awful.client.urgent.jumpto),

-- Swap clients into tag
	awful.key(
		{	modkey,				},	"q",
		function()
			awful.client.swap.byidx(1)
		end
	),
 	awful.key(
		{	modkey,				},	"w",
		function()
			awful.client.swap.byidx(-1)
		end
	),

-- Change layout geometry
-- Main column size
	awful.key(
		{	modkey,				},	"x",
		function()
		  awful.tag.incmwfact( 0.05)
		end
	),
	awful.key(
		{	modkey,				},	"z",
		function()
		  awful.tag.incmwfact(-0.05)
		end
	),
-- Decrease/increase rows into main column
	awful.key(
		{	modkey,	"Shift"		},	"z",
		function()
		  awful.tag.incnmaster(1)
		end
	),
	awful.key(
		{	modkey,	"Shift"		},	"x",
		function()
			awful.tag.incnmaster(-1)
		end
	),
-- Decrease/increase columns
	awful.key(
		{	modkey,	"Control"	},	"z",
		function()
			awful.tag.incncol(1)
		end
	),
	awful.key(
		{	modkey,	"Control"	},	"x",
		function()
			awful.tag.incncol(-1)
		end
	),

	-- Change layout
	awful.key(
		{	modkey,				},	"space",
		function()
			awful.layout.inc(1, mouse.screen, layouts)
		end
	),
	awful.key(
		{	modkey,	"Shift"		},	"space",
		function()
			awful.layout.inc(-1, mouse.screen, layouts)
		end
	),

	-- Unminimize
	awful.key(
		{	modkey,	"Control"	},	"w",
		function()
			local c = awful.client.restore(mouse.screen)
			client.focus = c
			c:raise()
		end
	),

-- Toggle switcher
	awful.key(
		{	modkey,				},	"\\",
		function()
			if awful.layout.get(mouse.screen.index) == awful.layout.suit.max then
				awful.layout.set(bosch.switcher.layout())
			elseif awful.layout.get(mouse.screen.index) == bosch.switcher.layout() then
				awful.layout.set(awful.layout.suit.max)
			end
		end
	),

-- Run application
	awful.key(
		{	modkey				},	"r",
		function()
			promptbox[mouse.screen.index]:run()
		end
	),
-- Show app menu (actually deactivated)
-- awful.key({ modkey }, "p", function() menubar.show() end),

-- Run commands (taken from config.lua)
-- Terminal
	awful.key(
		{	modkey,				},	"e",
		function()
			awful.util.spawn(config.commands.terminal)
		end
	),
-- File manager
	awful.key(
		{	modkey,	"Shift"		},	"e",
		function()
			awful.util.spawn(config.commands.filemanager)
		end
	),
-- Default browser
	awful.key(
		{	modkey				},	"g",
		function()
			awful.util.spawn(config.commands.browser)
		end
	),
-- Tiled browser
	awful.key(
		{	modkey,				},	"t",
		function()
			awful.util.spawn(config.commands.tiledbrowser)
		end
	),
-- Network manager
	awful.key(
		{	modkey,				},	"F1",
		function()
			awful.util.spawn(config.commands.netmanager)
		end
	),
-- Torrent application
	awful.key(
		{	modkey,				},	"F2",
		function()
			awful.util.spawn(config.commands.torrent)
		end
	),
-- Music player
	awful.key(
		{	modkey,				},	"F3",
		function()
			awful.util.spawn(config.commands.music)
		end
	),
-- Lock screen
	awful.key(
		{	modkey,				},	"l",
		function()
			awful.util.spawn(config.commands.lockscreen)
		end
	),

-- XF86 standard buttons (taken from config.lua)
-- Take screenshot
	awful.key(
		{						},	"Print",
		function()
			awful.util.spawn(config.commands.screenshot)
		end
	),
	awful.key(
		{	modkey,				},	"Print",
		function()
			awful.util.spawn(config.commands.screenrec)
		end
	),
-- Decrease/increase brightness
	awful.key(
		{	modkey,				},	"F5",
		function()
			awful.util.spawn(config.commands.brightdown)
		end
	),
	awful.key(
		{	modkey,				},	"F6",
		function()
			awful.util.spawn(config.commands.brightup)
		end
	),
-- Decrease/increase volume, toggle mute
	awful.key(
		{						},	"F2",
		function()
			awful.util.spawn(config.commands.voldown)
		end
	),
	awful.key(
		{						},	"F3",
		function()
			awful.util.spawn(config.commands.volup)
		end
	),
	awful.key(
		{						},	"F1",
		function()
			awful.util.spawn(config.commands.voltoggle)
		end
	)
-- Music: Play/stop, prev track, next track
-- awful.key({ }, "XF86AudioPlay", function () awful.util.spawn(config.commands.musicplay) end),
-- awful.key({ }, "XF86AudioPrev", function () awful.util.spawn(config.commands.musicprev) end),
-- awful.key({ }, "XF86AudioNext", function () awful.util.spawn(config.commands.musicnext) end)
)

-- Number keys related
for i = 1, 9 do
	globalkeys = awful.util.table.join(
		globalkeys,
		-- Move to n-th active tag
		awful.key(
			{	modkey			},	"#" .. i + 9,
			function()
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
			),
	-- Move client to n-th tag
		awful.key(
			{	modkey,	"Shift"	},	"#" .. i + 9,
			function ()
				local tag = awful.tag.gettags(client.focus.screen.index)[i]
				if client.focus and tag then
					awful.client.movetotag(tag)
				end
			end
		)
	)
end

-- Activate all global key shortcuts
root.keys(globalkeys)


-- Client Settings
clientkeys = {}
clientkeys = awful.util.table.join(
-- Quit client
	awful.key(
		{	modkey,	"Shift"		},	"q",
		function(c)
			c:kill()
		end
	),
-- Move client to default tag
	awful.key(
		{	modkey,				},	"b",
		function(c)
			local itsTag = bosch.tiling.getDefaultClientsTag(c)
			awful.client.movetotag(itsTag,c)
			itsTag:view_only()
		end
	),
-- Move client to left/right tag
	awful.key(
		{	modkey,	"Shift"		},	"a",
		function(c)
	 		c:move_to_tag(tags[c.screen.index][c.screen.selected_tag.index -1])
			awful.tag.viewprev(mouse.screen.index)
		end
	),
	awful.key(
		{	modkey,	"Shift"		},	"s",
		function(c)
	 		c:move_to_tag(tags[c.screen.index][c.screen.selected_tag.index +1])
			awful.tag.viewnext(mouse.screen.index)
		end
	),
-- Toggle fullscreen
	awful.key(
		{	modkey,				},	"f",
		function(c)
			c.fullscreen = not c.fullscreen
		end
	),
-- Toggle maximize
	awful.key(
		{	modkey,	"Shift"		},	"f",
		function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end
	),

	awful.key(
		{	modkey,	"Control"	},	"f",
		function(c)
			c.maximized_horizontal = false
			c.maximized_vertical   = false
			c.maximized = false
		end
	),
-- Minimize client
	awful.key(
		{	modkey,	"Shift"		},	"w",
		function(c)
			c.minimized = true
		end
	),
-- Toggle floating
	awful.key(
		{	modkey,	"Control"	},	"space",
		awful.client.floating.toggle
	),
-- Move client to other screen and give it focus
	awful.key(
		{	modkey,	"Shift"		},	"c",
		function(c)
			awful.client.movetoscreen(c, mouse.screen.index + 1)
		end
	),
-- Move client to other screen but keep focus
	awful.key(
		{	modkey,	"Shift"		},	"d",
		function(c)
			awful.client.movetoscreen(c, mouse.screen.index + 1)
			awful.screen.focus_relative( 1)
		end
	)
)

-- Focus/move/resize windows through mouse buttons
clientbuttons = {}
clientbuttons = awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- }}} ---------------------------------------------------------------------------

-- {{{ RULES --------------------------------------------------------------------
awful.rules.rules = {
  { rule = { },
    properties = { border_width = beautiful.border_width,
                   focus = awful.client.focus.filter,
                   keys = clientkeys,
                   buttons = clientbuttons,
                   size_hints_honor = false
    }
  },
  { rule={ class='Vlc' }, properties={ fullscreen=false } }

}

-- }}} ---------------------------------------------------------------------------

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
    --    if not c.size_hints.user_position and not c.size_hints.program_position then
    --      awful.placement.no_overlap(c)
    --      awful.placement.no_offscreen(c)
    --    end
  end
  local itsTag = tiling.openInTag(c)
  awful.client.movetotag(itsTag,c)
  itsTag:view_only()
  if c.type == "normal" or c.type == "dialog" then
    switcher.init_titlebar(c)
    tiling.focusBar(c)
  end
end)

--client.connect_signal("focus", function (c)
--    if c.class == "brave" or c.class == "Gimp" or c.class == "Gimp-2.8" then
--      awful.util.spawn("setxkbmap it")
--    else
--      awful.util.spawn("setxkbmap us")
--    end
--end)

tag.connect_signal("property::selected", function(t)
  if t.layout == awful.layout.suit.max then
  elseif t.layout == awful.layout.suit.max.fullscreen then
    t.gap = 0
  else
    t.gap = 8
  end
end)
tag.connect_signal("property::layout", function(t)
  clients = t:clients()
  local l = awful.layout.get(mouse.screen.index)
  if l == awful.layout.suit.max then
    for i, c in ipairs(clients) do
      awful.titlebar.hide(c)
    end
  elseif l == bosch.switcher.layout() then
    for i, c in ipairs(clients) do
      awful.titlebar.show(c)
    end
  else
    for i, c in ipairs(clients) do
      awful.titlebar.hide(c)
    end
  end

end)
-- }}} ---------------------------------------------------------------------------

return krs