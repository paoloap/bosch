---------------------------------------------------------------------------
--- BOSCH - theme.lua
--- Awesome WM beautiful variables definition
-- Released under GPL v3
-- To do: Order everything, comments
-- @author schuppenflektor
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.8
---------------------------------------------------------------------------
-- based on zenburn-custom, awesome3 theme, by Adrian C. (anrxc)

--{{{ Main
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

theme = {}

local shared         = "/usr/share/awesome"
local picsdir        = conf.dir.pics
local layoutsdir     = picsdir .. "/layouts/"
local wallpapers     = picsdir .. "/wallpapers"


local wallpaper1    = wallpapers .. "/background18.png"

if gears.filesystem.file_readable(wallpaper1) then
	theme.wallpaper = wallpaper1
end

-- dimensione separatore tra finestre
theme.font              = conf.makeup.font
theme.useless_gap       = conf.makeup.gap
theme.useless_gap_width = conf.makeup.gap
theme.border_width      = conf.makeup.border
theme.border_max        = conf.makeup.border_max
--theme.border_normal     = conf.makeup.color12
theme.border_normal     = conf.makeup.colorfg
theme.border_focus      = conf.makeup.color12
theme.fg_normal         = conf.makeup.color00
theme.fg_focus          = conf.makeup.color14
theme.fg_urgent         = conf.makeup.color12
--theme.bg_normal         = conf.makeup.transparent
--theme.bg_focus          = conf.makeup.transparent
--theme.bg_urgent         = conf.makeup.transparent

theme.tasklist_disable_icon = true

theme.wibar_fg             = conf.makeup.color00
theme.wibar_bg             = conf.makeup.transparent
theme.wibar_border_color   = conf.makeup.transparent
theme.taglist_fg_focus     = conf.makeup.color00
theme.taglist_bg_focus     = conf.makeup.color09
--theme.titlebar_fg_normal   = conf.makeup.color09

theme.focus_selected            = conf.makeup.color02
theme.focus_unselected          = conf.makeup.colorbg


theme.layout_max          = layoutsdir .. "max.png"
theme.layout_fullscreen   = layoutsdir .. "fullscreen.png"
theme.layout_floating     = layoutsdir .. "floating.png"
theme.layout_tile         = layoutsdir .. "tile.png"
theme.layout_dwindle      = layoutsdir .. "dwindle.png"
theme.layout_uselesstile  = layoutsdir .. "tile.png"
theme.layout_centerfair   = layoutsdir .. "centerfair.png"
theme.layout_termfair     = layoutsdir .. "termfair.png"
theme.layout_uselessfair  = layoutsdir .. "uselessfair.png"
theme.layout_centerwork   = layoutsdir .. "centerwork.png"

theme.system_cpu                = picsdir .. "system/cpu.png"
theme.system_mem                = picsdir .. "system/mem.png"
theme.audio_analog_on_speakers  = picsdir .. "audio/analog_speakers_on.png"
theme.audio_analog_on_jack      = picsdir .. "audio/analog_jack_on.png"
theme.audio_analog_off          = picsdir .. "audio/analog_off.png"
theme.audio_hdmi_on             = picsdir .. "audio/hdmi_on.png"
theme.audio_hdmi_off            = picsdir .. "audio/hdmi_off.png"
theme.audio_bluetooth_on        = picsdir .. "audio/bluetooth_on.png"
theme.audio_bluetooth_off       = picsdir .. "audio/bluetooth_off.png"
theme.audio_mpd_local           = picsdir .. "audio/mpd_local.png"
theme.audio_mpd_youtube         = picsdir .. "audio/mpd_youtube.png"
theme.audio_mpd_soundcloud      = picsdir .. "audio/mpd_soundcloud.png"
theme.widget_void		= picsdir .. "widgets/void.png"
theme.network_disconnected      = picsdir .. "network/disconnected.png"
theme.network_connecting        = picsdir .. "network/connecting.png"
theme.network_wifi              = picsdir .. "network/wifi.png"
theme.network_ethernet          = picsdir .. "network/wired.png"
theme.network_download          = picsdir .. "network/download.png"
theme.network_download_stress   = picsdir .. "network/download_stress.png"
theme.network_upload            = picsdir .. "network/upload.png"
theme.network_upload_stress     = picsdir .. "network/upload_stress.png"





naughty.config.presets.normal.fg               = conf.makeup.colorfg
naughty.config.presets.normal.bg               = conf.makeup.colorbg
naughty.config.presets.normal.border_color     = conf.makeup.colorfg
naughty.config.presets.normal.border_width     = conf.makeup.border
-- }}}
--
return theme
