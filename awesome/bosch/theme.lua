---------------------------------------------------------------------------
--- BOSCH - theme.lua
--- Awesome WM beautiful variables definition
-- Released under GPL v3
-- To do: Order everything, comments
-- @author schuppenflektor
-- @copyright 2016 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.6
---------------------------------------------------------------------------
-- based on zenburn-custom, awesome3 theme, by Adrian C. (anrxc)

--{{{ Main
local awful = require("awful")
awful.util = require("awful.util")
local config = require("bosch.config")
local naughty = require("naughty")

theme = {}

home          = os.getenv("HOME")
confdir        = awful.util.getdir("config")
shared        = "/usr/share/awesome"
if not awful.util.file_readable(shared .. "/icons/awesome16.png") then
    shared    = "/usr/share/local/awesome"
end
themename     = "/bosch"
picsdir      = confdir .. themename .. "/pics"
iconsdir       = picsdir .. "/icons"
layoutsdir    = picsdir .. "/layouts"
wallpapers    = picsdir .. "/wallpapers"


wallpaper1    = wallpapers .. "/background16.png"

if awful.util.file_readable(wallpaper1) then
	theme.wallpaper = wallpaper1
elseif awful.util.file_readable(wallpaper2) then
	theme.wallpaper = wallpaper2
elseif awful.util.file_readable(wpscript) then
	theme.wallpaper_cmd = { "sh " .. wpscript }
elseif awful.util.file_readable(wallpaper3) then
	theme.wallpaper = wallpaper3
else
	theme.wallpaper = wallpaper4
end

-- dimensione separatore tra finestre
theme.useless_gap = config.gap
theme.useless_gap_width = config.gap

--}}}

-- {{{ Styles
theme.font      = config.font
theme.tasklist_disable_icon = true
-- }}}
-- {{{ Colors and Borders
--

-- Bosch Wibox
theme.fg_bwibox =		config.colorbg
theme.bg_bwibox =		config.transparent
theme.fg_bwibox_seltag =	config.color14
theme.bg_bwibox_seltag =	config.colorfg
theme.fg_bwibox_urgent =	config.color12


-- Clients
theme.border_width =		config.border
theme.border_width_max =	config.border_max
theme.border_color_max = 	config.colorbg
theme.border_normal =		config.colorbg
theme.border_focus =		config.color12

-- Switcher
theme.switcher_border_width =	config.border_switcher
theme.fg_switcher_normal =	config.colorbg
theme.bg_switcher_normal =	config.color08
theme.fg_switcher_focus =	config.colorbg
theme.bg_switcher_focus =	config.color12

-- General
theme.fg_normal = 		config.colorbg
theme.fg_focus  = 		config.color14
theme.fg_urgent = 		config.color12
theme.bg_normal = 		config.transparent
theme.bg_focus  = 		config.transparent
theme.bg_urgent = 		config.transparent

-- Notifications
theme.notify_bg = 		config.colorbg
theme.notify_fg = 		config.colorfg
theme.notify_border = 		config.color12
theme.notify_border_width = 	config.border

-- }}}

-- {{{ Layout icons
theme.layout_max          = picsdir .. "/layouts/max.png"
theme.layout_fullscreen   = picsdir .. "/layouts/fullscreen.png"
theme.layout_floating     = picsdir .. "/layouts/floating.png"
theme.layout_tile         = picsdir .. "/layouts/tile.png"
theme.layout_dwindle      = picsdir .. "/layouts/dwindle.png"
theme.layout_uselesstile  = picsdir .. "/layouts/tile.png"
theme.layout_centerfair   = picsdir .. "/layouts/centerfair.png"
theme.layout_termfair     = picsdir .. "/layouts/termfair.png"
theme.layout_uselessfair  = picsdir .. "/layouts/uselessfair.png"
theme.layout_centerwork   = picsdir .. "/layouts/centerwork.png"
-- }}}

-- {{{ Widget icons

theme.widget_fs     = picsdir .. "/widgets/disk.png"
theme.widget_mem    = picsdir .. "/widgets/mem.png"
theme.widget_cpu    = picsdir .. "/widgets/cpu.png"
theme.widget_net    = picsdir .. "/widgets/download.png"
theme.widget_netup  = picsdir .. "/widgets/upload.png"
theme.widget_netgoing    = picsdir .. "/widgets/download_going.png"
theme.widget_netupgoing    = picsdir .. "/widgets/upload_going.png"
theme.widget_vol_on = picsdir .. "/widgets/vol_on.png"
theme.widget_jack = picsdir .. "/widgets/jack.png"
theme.widget_hdmi = picsdir .. "/widgets/hdmi.png"
theme.widget_vol_off = picsdir .. "/widgets/vol_off.png"
theme.widget_music  = picsdir .. "/widgets/music.png"
theme.widget_ac_full = picsdir .. "/widgets/ac_full.png"
theme.widget_ac     = picsdir .. "/widgets/ac.png"
theme.widget_bat_full   = picsdir .. "/widgets/bat_full.png"
theme.widget_bat_med    = picsdir .. "/widgets/bat_med.png"
theme.widget_bat_low    = picsdir .. "/widgets/bat_low.png"
theme.widget_bat_empty  = picsdir .. "/widgets/bat_empty.png"
theme.widget_nomail = picsdir .. "/widgets/nomail.png"
theme.widget_newmail = picsdir .. "/widgets/newmail.png"

theme.widget_disconnected 	= picsdir .. "/widgets/noconn.png"
theme.widget_connecting         = picsdir .. "/widgets/connecting.png"
theme.widget_wifi 		= picsdir .. "/widgets/wifi.png"
theme.widget_wired 		= picsdir .. "/widgets/wired.png"
theme.widget_usb                = picsdir .. "/widgets/usb.png"

theme.widget_therm_low          = picsdir .. "/widgets/therm_low.png"
theme.widget_therm_med          = picsdir .. "/widgets/therm_med.png"
theme.widget_therm_high         = picsdir .. "/widgets/therm_high.png"
theme.widget_therm_crit         = picsdir .. "/widgets/therm_crit.png"

theme.tag_browser = picsdir .. "/tags/browser.png"
theme.tag_geek = picsdir .. "/tags/geek.png"
theme.tag_write = picsdir .. "/tags/write.png"
theme.tag_chat = picsdir .. "/tags/chat.png"
theme.tag_work = picsdir .. "/tags/work.png"
theme.tag_guis = picsdir .. "/tags/guis.png"
theme.tag_admin = picsdir .. "/tags/admin.png"
theme.tag_show = picsdir .. "/tags/show.png"
theme.tag_music = picsdir .. "/tags/music.png"

naughty.config.presets.normal.fg               = theme.notify_fg
naughty.config.presets.normal.bg               = theme.notify_bg
naughty.config.presets.normal.border_color     = theme.notify_border
naughty.config.presets.normal.border_width     = theme.notify_border_width
-- }}}
--
return theme
