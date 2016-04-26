-- bosch, awesome3 theme, Paolo P. (paoloap | ppaoloapp | schuppenflektor)
-- based on zenburn-custom, awesome3 theme, by Adrian C. (anrxc)

--{{{ Main
local awful = require("awful")
awful.util = require("awful.util")

theme = {}

home          = os.getenv("HOME")
config        = awful.util.getdir("config")
shared        = "/usr/share/awesome"
if not awful.util.file_readable(shared .. "/icons/awesome16.png") then
    shared    = "/usr/share/local/awesome"
end
sharedthemes  = shared .. "/themes"
sharedicons   = shared .. "/icons"
themes        = config .. "/themes"
themename     = "/brontosaurus"
if not awful.util.file_readable(themes .. themename .. "/theme.lua") then
       themes = sharedthemes
end
themedir      = themes .. themename

wallpaper1    = themedir .. "/background.jpg"
wallpaper2    = themedir .. "/background.png"
wallpaper4    = sharedthemes .. "/default/background.png"
wpscript      = home .. "/.wallpaper"

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
theme.useless_gap_width = 10

--}}}

-- {{{ Styles
theme.font      = "Monospace 8"
theme.tasklist_disable_icon = true

-- {{{ Colors
theme.fg_normal = "#FFFFFF"
theme.fg_focus  = "#F1D8A0"
theme.fg_urgent = "#CC9393"
theme.bg_normal = "#000000"
theme.bg_focus  = "#000000"
theme.bg_urgent = "#000000"
-- }}}

-- {{{ Borders
theme.border_width  = "2"
theme.border_normal = "#000000"
theme.border_focus = "#000000"
theme.border_marked = "#000000"
-- }}}


-- {{{ Widgets
theme.fg_widget        = "#AECF96"
theme.fg_center_widget = "#88A175"
theme.fg_end_widget    = "#FF5656"
theme.fg_off_widget    = "#494B4F"
theme.fg_netup_widget  = "#7F9F7F"
theme.fg_netdn_widget  = "#CC9393"
theme.bg_widget        = "#4F4F4F"
theme.border_widget    = "#4F4F4F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- theme.mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Tooltips
-- theme.tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- }}}


-- {{{ Icons
--
-- {{{ Taglist icons
theme.taglist_squares_sel   = themedir .. "/taglist/squarefz.png"
theme.taglist_squares_unsel = themedir .. "/taglist/squareza.png"
theme.taglist_squares_resize = "false"

-- }}}

-- {{{ Misc icons
--theme.awesome_icon           = themedir .. "/awesome.png"
--theme.menu_submenu_icon      = sharedthemes .. "/default/submenu.png"
--theme.tasklist_floating_icon = sharedthemes .. "/default/tasklist/floatingw.png"
-- }}}

-- {{{ Layout icons
theme.layout_max          = themedir .. "/layouts/max.png"
theme.layout_fullscreen   = themedir .. "/layouts/fullscreen.png"
theme.layout_floating     = themedir .. "/layouts/floating.png"
theme.layout_uselesstile  = themedir .. "/layouts/tile.png"
theme.layout_centerfair   = themedir .. "/layouts/centerfair.png"
theme.layout_termfair     = themedir .. "/layouts/termfair.png"
theme.layout_uselessfair  = themedir .. "/layouts/uselessfair.png"
theme.layout_centerwork   = themedir .. "/layouts/centerwork.png"
-- }}}

-- {{{ Widget icons
-- theme.widget_mail   = themedir .. "/icons/gigamo/mail.png"
-- theme.widget_vol    = themedir .. "/icons/gigamo/vol.png"
-- theme.widget_org    = themedir .. "/icons/gigamo/cal.png"
-- theme.widget_date   = themedir .. "/icons/gigamo/time.png"
-- theme.widget_crypto = themedir .. "/icons/gigamo/crypto.png"


theme.widget_fs     = themedir .. "/icons/disk.png"
theme.widget_mem    = themedir .. "/icons/mem.png"
theme.widget_cpu    = themedir .. "/icons/cpu.png"
theme.widget_net    = themedir .. "/icons/download.png"
theme.widget_netup  = themedir .. "/icons/upload.png"
theme.widget_music  = themedir .. "/icons/music.png"

theme.widget_ac     = themedir .. "/icons/ac.png"
theme.widget_bat_full   = themedir .. "/icons/bat_full.png"
theme.widget_bat_med    = themedir .. "/icons/bat_med.png"
theme.widget_bat_low    = themedir .. "/icons/bat_low.png"
theme.widget_bat_empty  = themedir .. "/icons/bat_empty.png"

theme.widget_disconnected 	= themedir .. "/icons/noconn.png"
theme.widget_wifi 		= themedir .. "/icons/wifi.png"
theme.widget_wired 		= themedir .. "/icons/wired.png"

-- }}}

-- {{{ Titlebar icons
theme.titlebar_close_button_focus  = themedir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themedir .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active    = themedir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active   = themedir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themedir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themedir .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active    = themedir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active   = themedir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themedir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themedir .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active    = themedir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active   = themedir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themedir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themedir .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    = themedir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = themedir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themedir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themedir .. "/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme