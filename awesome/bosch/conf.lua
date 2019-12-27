---------------------------------------------------------------------------
--- BOSCH - conf.lua
--- Configuration file. Here user can set every customizable value
-- Released under GPL v3
-- @author barrotes
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.9.0
-- @module bosch.conf
---------------------------------------------------------------------------

local conf = {}

conf.makeup          =
{
   font              = "Input Mono Compressed 11";
   transparent       = "#00000000";
   colorfg           = "#555555";
   colorbg           = "#f0f0f0";
   color00           = "#1d1f21";
   color01           = "#ff49c0";
   color02           = "#00f0c8";
   color03           = "#ff49c0";
   color04           = "#00f0c8";
   color05           = "#ff49c0";
   color06           = "#00f0c8";
   color07           = "#6c6e6d";
   color08           = "#b0b2b0";
   color09           = "#ff49c0";
   color10           = "#00c1a1";
   color11           = "#ff49c0";
   color12           = "#00c1a1";
   color13           = "#ff49c0";
   color14           = "#729d97";
   color15           = "#1d1f21";
   gap               = 7;
   border            = 4;
   border_max        = 4;
   border_switcher   = 2;
}

conf.modules               =
{
   screen                  =
   {
      barble               =
      {
         position          = "top",
         height            = "20",
         elements_first    =
         {
            "_taglist",
            "separator",
            "_prompt",
         },
         elements_second   =
         {
            "_titlebar",
                 -- "_minimized",
            stacked
         },
         elements_third    =
         {
            "wible_mpd",
            "wible_pulse",
            "separator",
            "sysinfo",
            "separator",
            "wible_netctl",
            "wible_traffic",
            "separator",
            -- "wible_info",
            -- "separator",
            "textclock",
            "_layoutbox"
         }
      }
   },
   client                     =
   {
      focus_blink = { position = "bottom", size = 6 },
      ninja_title = { position = "top", size = 15 },
   }
}

local boschdir = awful.util.getdir("config") .. "bosch/"
conf.dir =
{
   bosch = boschdir,
   bash  = boschdir .. "lib/bash/",
   pics  = boschdir .. "lib/media/",
   walls = boschdir .. "lib/media/wallpapers/",
   cache = boschdir .. ".cache/",
   core  = boschdir .. "core/"
}
--naughty.notify({text = conf.dir.bash})

-- Set the basekeys as short local variables to improve readability into conf.shortcuts table
conf.commands        =
{
   terminal          = {   "termite -r terminal",                                }, 
   filemanager       = {   "thunar",                                             }, 
   browser           = {   conf.dir.bash .. "browser.sh",                        }, 
   tiledbrowser      = {   conf.dir.bash .. "tiledbrowser.sh",                   }, 
   torrent           = {   "termite -e transmission-remote-cli",                 }, 
   music_player      = {   "termite -e ncmpcpp",                                 }, 
   lock_screen       = {   conf.dir.bash .. "lock_screen.sh",                    }, 
   screenshot        = {   conf.dir.bash .. "screenshot.sh",      "screenshot"   }, 
   rec_screen        = {   conf.dir.bash .. "rec_screen.sh",                     }, 
   bright_down       = {   "xbacklight -dec 15",                                 }, 
   bright_up         = {   "xbacklight -inc 15",                                 },
   vol_down          = {   conf.dir.bash .. "vol_down.sh",        "volume"       },
   vol_up            = {   conf.dir.bash .. "vol_up.sh",          "volume"       },
   vol_toggle        = {   conf.dir.bash .. "vol_toggle.sh",      "volume"       },
   sink_change       = {   conf.dir.bash .. "sink_change.sh",     "volume"       },
   music_play        = {   "mpc-pause",                           "mpd"          },
   music_prev        = {   "mpc prev",                            "mpd"          },
   music_next        = {   "mpc next",                            "mpd"          },
}


local mod = "Mod4"
local shi = "Shift"
local ctl = "Control"
local alt = "Alt"
local spa = "space"
local esc = "Escape"
local pri = "Print"
local tab = "Tab"
local bsl = "\\"
local lov = "XF86AudioLowerVolume"
local hiv = "XF86AudioRaiseVolume"
local muv = "XF86AudioMute"
local lol = "XF86MonBrightnessDown"
local hil = "XF86MonBrightnessUp"
conf.modkey = mod
conf.keybindings        =
{
   global               =
   {
      terminal          = {   mod,        "e"   },
      filemanager       = {   mod,  shi,  "e"   },
      browser           = {   mod,        "g"   },
      tiledbrowser      = {   mod,  shi,  "g"   },
      torrent           = {   mod,        "t"   },
      music_player      = {   mod,        "m"   },
      lock_screen       = {   mod,        "l"   },
      screenshot        = {               pri   },
      recscreen         = {   mod,        pri   },
      brightdown        = {               lol   },
      brightup          = {               hil   },
      vol_down          = {               lov   },
      vol_up            = {               hiv   },
      vol_toggle        = {               muv   },
      sink_change       = {   mod,        lov   },
      music_play        = {   mod,  shi,  muv   },
      music_prev        = {   mod,  shi,  lov   },
      music_next        = {   mod,  shi,  hiv   },
      run_cmd           = {   mod,        "r"   },
      wm_restart        = {   mod,  ctl,  "r"   },
      wm_quit           = {   mod,  ctl,  "q"   },
      left_tag          = {   mod,        "a"   },
      right_tag         = {   mod,        "s"   },
      last_tag          = {   mod,        esc   },
      screen_focus      = {   mod,        "d"   },
      tag_focus_left    = {   mod,        tab   },
      tag_focus_right   = {   mod,  shi,  tab   },
      left_inc          = {   mod,        "x"   },
      right_inc         = {   mod,        "z"   },
      left_add_row      = {   mod,  shi,  "z"   },
      left_rem_row      = {   mod,  shi,  "x"   },
      right_add_col     = {   mod,  ctl,  "x"   },
      right_rem_col     = {   mod,  ctl,  "z"   },
      layout_next       = {   mod,        spa   },
      layout_prev       = {   mod,  shi,  spa   },
      unminimize        = {   mod,  ctl,  "w"   },
      toggle_wibar      = {   mod,        "k"   },
      switcher          = {   mod,        bsl   },
      xrandr            = {   mod, "j" },
   },
   client               =
   {
      quit              = {   mod,  shi,  "q"   },
      fullscreen        = {   mod,        "f"   },
      maximize          = {   mod,  shi,  "f"   },
      force_unmax       = {   mod,  ctl,  "f"   },
      float             = {   mod,  ctl,  spa   },
      minimize          = {   mod,  shi,  "w"   },
      default_tag_bg    = {   mod,        "b"   },
      default_tag_go    = {   mod,  shi,  "b"   },
      tag_left          = {   mod,  shi,  "a"   },
      tag_right         = {   mod,  shi,  "s"   },
      screen            = {   mod,  ctl,  "d"   },
      screen_focus      = {   mod,  shi,  "d"   },
      swap_next         = {   mod,        "q"   },
      swap_prev         = {   mod,        "w"   },
   }
}


local br = "browser"
local ge = "geek"
local wo = "work"
local ch = "chat"
local wr = "write"
local ad = "admin"
local ma = "maximized"
local vi = "video"
local mu = "music"
local fl = "floating"
conf.tiling =
{
   layouts  = { "float", "tile", "termfair", "centerwork", "spiral", "max" },
   displays =
   {
      eDP1  = { "main",  { br, ge, wo, wr, ch, ma, vi, mu, fl } },
      HDMI1 = { "above", { vi, mu, br } },
      VGA1  = { "above", { ge, wo, ma } }
   },
   tags     =
   {
      browser     = { layout_set = { "max", "tile" } },
      geek        = { layout_set = { "tile", "termfair", "centerwork" } },
      write       = { layout_set = { "centerwork" }, tag_props  = { gap = 60 } },
      chat        = { layout_set = { "termfair", "tile" } },
      work        = { layout_set = { "tile", "termfair", "centerwork", "max" }, tag_props = { master_count = 2 } },
      maximized   = { layout_set = { "max" } },
      admin       = { layout_set = { "tile" } },
      video       = { layout_set = { "tile", "max" } },
      music       = { layout_set = { "termfair", "centerwork", "max" }, tag_props  = { gap = 70 } },
      floating    = { layout_set = { "float" }, client_props = { titlebars_enabled } },
   }
}

conf.clients           =
{
   termite        =
   {
      rule        = { class = "Termite", role = "terminal" },
      --no_titlebar = true,
      tiling      = { default = ge, forbidden = { br, ma } },
   },
   thunar         =
   {
      rule        = { class = "Thunar" },
      tiling      = { default = ge, forbidden = { br, mu, ma, wr } },
   },
   ncmpcpp        =
   {
      rule        = { class = "Termite"; name = "ncmpcpp .+" },
      tiling      = { default = mu, forbidden = { br, wo, ma, vi, wr, ad } },
   },
   telegram       =
   {
      rule        = { class = "TelegramDesktop" },
      tiling      = { default = ch, forbidden = { br, wo, wr, ad, ma, vi, mu } },
   },
   vlc_main       =
   {
      rule        = { class = "vlc", role = "vlc-main" },
      tiling      = { default = vi, forbidden = { br, wo, ma, wr, ad }, screen = "HDMI1" },
   },
   vlc_controls   =
   {
      rule        = { class = "vlc", name = "vlc" },
      --properties  = { border_width = 0},
      tiling      = { default = vi, forbidden = { br, wo, ma, wr, ad }, screen = "HDMI1" },
      background  = true,
      no_titlebar = true,
      unpimpable  = true,
      ghost       = true
   },
   vlc_playlist   =
   {
      rule        = { class = "vlc", role = "vlc-playlist" },
      tiling      = { default = vi, forbidden = { br, wo, ch, ma, mu } },
   },
   firefox        =
   {
      rule        = { class = "firefox", role = "browser" },
      tiling      = { default = br, forbidden = { ge, wo, ch, ma, vi, mu, wr }, screen = "eDP1" },
   },
   virtualbox     =
   {
      rule        = { class = "VirtualBox .+" },
      tiling      = { default = ma, forbidden = { ge, wo, ch, br, vi, mu, wr, ad, fl } },
   },
   gimp           =
   {
      rule        = { class = "Gimp" },
      properties  = { maximized = true },
      tiling      = { default = ma, forbidden = { ge, wo, ch, br, vi, mu, wr, ad, fl } },
   },
   libreoffice    =
   {
      rule        = { class = ".*", name = ".*LibreOffice.*" },
      properties  = { maximized = true },
      tiling      = { default = ma, forbidden = { ge, wo, ch, br, vi, mu, wr, ad, fl } },
      background = true,
   },
}



return conf
