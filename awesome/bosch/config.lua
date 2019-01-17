---------------------------------------------------------------------------
--- BOSCH - config.lua
--- Configuration file. Here user can set every customizable value
-- Released under GPL v3
-- @author schuppenflektor
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.8
---------------------------------------------------------------------------

local awful = require("awful")
local lain = require("lain")
-- local functions = require("bosch.utils.functions")
config = {
	tiling = {};
	bwibox = {};
   audio = {}
}

config.dir              = awful.util.getdir("config")
config.bosch	            = config.dir .. "bosch"
config.theme	            = config.bosch .. "/theme.lua"
config.pics             = config.bosch .. "/pics"
config.scripts          = config.bosch .. "/scripts"
config.tmpdir           = config.bosch .. "/.cache"
config.mail             = config.dir .. "../../.mail/inbox"

config.tmpfiles =
{
   traffic = config.tmpdir .. "/traffic"
}
-- probably config.terminal and config.editor are not mandatory...
config.terminal	        = "termite"
config.editor           = "vim"
config.launch_in_term	   = config.terminal .. " -e "
config.editor_cmd       = config.launch_in_term .. config.editor

-- THEME OPTIONS

-- we don't use skins yet, but i plan to implement them soon or later.
config.skin                = "autumn";
config.modkey              = "Mod4"
-- font
config.font	               = "Share Tech Mono 10";
-- colors
config.transparent	         = "#00000000";
config.colorfg             = "#373b41";
config.colorbg             = "#f0f0f0";
config.color00             = "#1d1f21";
config.color01             = "#ff49c0";
config.color02             = "#00f0c8";
config.color03             = "#ff49c0";
config.color04             = "#00f0c8";
config.color05             = "#ff49c0";
config.color06             = "#00f0c8";
config.color07             = "#6c6e6d";
config.color08             = "#b0b2b0";
config.color09             = "#ff49c0";
config.color10             = "#00c1a1";
config.color11             = "#ff49c0";
config.color12             = "#00c1a1";
config.color13             = "#ff49c0";
config.color14             = "#729d97";
config.color15             = "#1d1f21";
-- margins and borders
config.gap						= "8";
config.border					= "2";
config.border_max				= "2";
config.border_switcher		= "2";

-- COMMAND OPTIONS
-- Default commands, connected with several functions and events
config.commands = {
  terminal					= "termite";
  filemanager				= "thunar";
  browser						= "brws";
  tiledbrowser				= "tiledvimb";
  netmanager            = "termite -e wicd-curses -t wicd";
  torrent               = "termite -e transmission-remote-cli";
  music                 = "termite -e ncmpcpp";
  lockscreen            = config.scripts .. "/lockscreen.sh"; -- depends on i3lock
  screenshot            = config.scripts .. "/screenshot.sh 0 0 png"; -- depends on imagemagick
  screenrec             = config.scripts .. "/screenrec.sh 10"; -- depends on ffmpeg
  brightdown            = "xbacklight -dec 15";
  brightup              = "xbacklight -inc 15";
  voldown               = "pactl -- set-sink-volume `pacmd list-sinks| grep '* index' | sed 's/^.*index: //'` -5%";
  volup                 = "pactl -- set-sink-volume `pacmd list-sinks| grep '* index' | sed 's/^.*index: //'` +5%";
  voltoggle             = "pactl set-sink-mute `pacmd list-sinks| grep '* index' | sed 's/^.*index: //'` toggle";
  sinkchange		= config.scripts .. "/change_default_sink.sh";
  musicplay             = "mpc-pause";
  musicprev             = "mpc prev";
  musicnext             = "mpc next";
  data = {
     pulseaudio             = "pacmd list-sinks | sed -r 's/^[ ]*[\t]*//'" .. ' | grep -e "^volume:" -e "^active port:" -e "^muted: " -e "^[ \\* ]*index: "';
     mpd                = 'echo -e "status\ncurrentsong\nclose" | curl telnet://127.0.0.1:6600 -fsm 1 | grep -e "^state: " -e "^file: " -e "^Name: " -e "^Title: " -e "^Artist: "'
     }
}

-- TILING OPTIONS

-- tiling.tags: an array which represents all possible tag types
-- tagtypes.[key].name: [key] tag name
-- tagtypes.[key].ico: [key] tag icon
-- tagtypes.[key].layout: [key] tag's default layout
-- tagtypes.[key].key: used to refer to x tag from tiling.clients array's elements

-- Lain layout settings
lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 2
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
-- lain.layout.centerwork.top_left = 0
-- lain.layout.centerwork.top_right = 1
-- lain.layout.centerwork.bottom_left = 2
-- lain.layout.centerwork.bottom_right = 3


config.tiling.layouts = {
   awful.layout.suit.floating,
   awful.layout.suit.tile,
   lain.layout.termfair.center,
   lain.layout.centerwork,
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.max
   --layout.fullscreen
}


config.tiling.tagtypes = {
   b = {
      name = "browser";
      icon = config.pics .. "/tags/browser.png";
      layout = awful.layout.suit.max;
   },
   T = {
      name = "geek";
      icon = config.pics .. "/tags/geek.png";
      layout = awful.layout.suit.tile;
   },
   d = {
      name = "distraction-free";
      icon = config.pics .. "/tags/write.png";
      layout = lain.layout.centerwork;
   },
   t = {
      name = "chat";
      icon = config.pics .. "/tags/chat.png";
      layout = lain.layout.termfair.center;
   },
   w = {
      name = "work";
      icon = config.pics .. "/tags/work.png";
      layout = awful.layout.suit.tile;
   },
   M = {
      name = "max-apps";
      icon = config.pics .. "/tags/guis.png";
      layout = awful.layout.suit.max;
   },
   a = {
      name = "admin";
      icon = config.pics .. "/tags/admin.png";
      layout = awful.layout.suit.tile;
   },
   v = {
      name = "video";
      icon = config.pics .. "/tags/show.png";
      layout = awful.layout.suit.tile;
   },
   m = {
      name = "music";
      icon = config.pics .. "/tags/music.png";
      layout = lain.layout.centerwork;
   }
}
config.tiling.displays = {
   {
      name = "eDP1";
      scheme = {
         config.tiling.tagtypes.b,
         config.tiling.tagtypes.T,
         config.tiling.tagtypes.d,
         config.tiling.tagtypes.t,
         config.tiling.tagtypes.w,
         config.tiling.tagtypes.M,
         config.tiling.tagtypes.a,
         config.tiling.tagtypes.v,
         config.tiling.tagtypes.m,
      }
   },
   {
      name = "VGA1";
      scheme = {
         config.tiling.tagtypes.w,      
         config.tiling.tagtypes.v,
         config.tiling.tagtypes.m
      }
   },
   {
      name = "HDMI1";
      scheme = {
         config.tiling.tagtypes.v,
         config.tiling.tagtypes.m
      }
   }
}


-- tiling.clients: an array which represents the tag properties that apply to some clients.
-- client c is univoquely represented by the parameters c.class and c.name which are based on xorg properties
-- tiling.clients[x].class: x-th client class xorg property
-- tiling.clients[x].name: x-th client name xorg property. If it's set to "###" then x-th element refers
--   to an entire class, with the exceptions of the clients with same class and a name explicitely defined. 
-- tiling.clients[x].type: x-th client's default tag key. If when we launch the client we are into a forbidden tag,
--   then the client is moved to the tag having to tiling.tags[].key with this value
-- tiling.clients[x].forbidden: an array with x-th client's forbidden tag. If when we launch the client we are
-- into a tag with one of these keys, then the client is moved to its default tag.

config.tiling.clients = {
   { class = "Termite", name = "ncmpcpp", default = "m", forbidden = {"b","T","d","t","w","M","a","v"} };
   { class = "Termite", name = "MPD", default = "m", forbidden = {"b","T","d","t","w","M","a","v"} };
   { class = "Termite", name = "wicd", default = "a", forbidden = {"b","d","t","M","v","m"} };
   { class = "Termite", name = "rtv", default = "t", forbidden = {"b","d","w","M","v","m"} };
   { class = "TelegramDesktop", name = "###", default = "t", forbidden = {"b","d","w","M","v","m"} };
   { class = "Termite", name = "htop", default = "a", forbidden = {"b","M","v","m"} };
   { class = "Termite", name = "pacaur", default = "a", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "sudo pacman", default = "a", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "root", default = "a", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "ranger", default = "t", forbidden = {"b","M","v","m"} };
   { class = "Termite", name = "hangups", default = "t", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "newsbeuter", default = "t", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "turses", default = "t", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "mutt", default = "w", forbidden = {"b","M","v","m"} };
   { class = "Termite", name = "###", default = "T", forbidden = {"b","M"} };
   { class = "Vimb", name = "vimb-main", default = "b", forbidden = {"T","d","w","a","M","v","m"} };
   { class = "Vimb", name = "vimb-tiled", default = "t", forbidden = {"b","M","v","m"} };
   { class = "vlc", name = "###", default = "v", forbidden = {"b","d","M","m"} };
   { class = "Pavucontrol", name = "###", default = "v", forbidden = {"b","d","M","m"} };
   { class = "Thunar", name = "###", default = "T", forbidden = {"b","d","M","m"} };
   { class = "Chromium", name = "###", default = "b", forbidden = {"T","d","w","a","M","v","m"} };
   { class = "Firefox", name = "###", default = "b", forbidden = {"T","d","t","w","a","M","v","m"} };
   { class = "brave", name = "###", default = "b", forbidden = {"T","d","w","a","M","v","m"} };
   { class = "google-chrome", name = "###", default = "b", forbidden = {"T","d","w","a","M","v","m"} };
   { class = "Sxiv", name = "###", default = "d", forbidden = {"b","w","M","v","m"} };
   { class = "Gimp-2.10", name = "###", default = "M", forbidden = {"b","T","d","w","a","v","m"} };
   { class = "libreoffice-writer", name = "###", default = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
   { class = "libreoffice-calc", name = "###", default = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
   { class = "libreoffice-startcenter", name = "###", default = "M", forbidden = {"b","T","t","d","w","a","v","m"} };
   { class = "VirtualBox", name = "###", default = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
   { class = "rdesktop", name = "###", default = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
   { class = "soulseekqt", name = "###", default = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
   { class = "Wicd-client.py", name = "###", default = "a", forbidden = {"b","d","w","M","v","m"} };
   { class = "jetbrains-idea-ce", name = "###", default = "M", forbidden = {"b","T","d","t","w","a","v","m"} }
}
-- local tt = config.tiling.tagtypes
-- config.tiling.clients = {
--    { class = "Termite", name = "ncmpcpp", type = "m", forbidden = {"b","T","d","t","w","M","a","v"} };
--    { class = "Termite", name = "MPD", type = "m", forbidden = {"b","T","d","t","w","M","a","v"} };
--    { class = "Termite", name = "wicd", type = "a", forbidden = {"b","d","t","M","v","m"} };
--    { class = "Termite", name = "rtv", type = "t", forbidden = {"b","d","w","M","v","m"} };
--    { class = "TelegramDesktop", name = "###", type = "t", forbidden = {"b","d","w","M","v","m"} };
--    { class = "Termite", name = "htop", type = "a", forbidden = {"b","M","v","m"} };
--    { class = "Termite", name = "pacaur", type = "a", forbidden = {"b","d","M","v","m"} };
--    { class = "Termite", name = "sudo pacman", type = "a", forbidden = {"b","d","M","v","m"} };
--    { class = "Termite", name = "root", type = "a", forbidden = {"b","d","M","v","m"} };
--    { class = "Termite", name = "ranger", type = "t", forbidden = {"b","M","v","m"} };
--    { class = "Termite", name = "hangups", type = "t", forbidden = {"b","d","M","v","m"} };
--    { class = "Termite", name = "newsbeuter", type = "t", forbidden = {"b","d","M","v","m"} };
--    { class = "Termite", name = "turses", type = "t", forbidden = {"b","d","M","v","m"} };
--    { class = "Termite", name = "mutt", type = "w", forbidden = {"b","M","v","m"} };
--    { class = "Termite", name = "###", type = "T", forbidden = {"b","M"} };
--    { class = "Vimb", name = "vimb-main", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
--    { class = "Vimb", name = "vimb-tiled", type = "t", forbidden = {"b","M","v","m"} };
--    { class = "vlc", name = "###", type = "v", forbidden = {"b","d","M","m"} };
--    { class = "Pavucontrol", name = "###", type = "v", forbidden = {"b","d","M","m"} };
--    { class = "Thunar", name = "###", type = "T", forbidden = {"b","d","M","m"} };
--    { class = "Chromium", name = "###", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
--    { class = "Firefox", name = "###", type = "b", forbidden = {"T","d","t","w","a","M","v","m"} };
--    { class = "brave", name = "###", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
--    { class = "google-chrome", name = "###", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
--    { class = "Sxiv", name = "###", type = "d", forbidden = {"b","w","M","v","m"} };
--    { class = "Gimp-2.10", name = "###", type = "M", forbidden = {"b","T","d","w","a","v","m"} };
--    { class = "libreoffice-writer", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
--    { class = "libreoffice-calc", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
--    { class = "libreoffice-startcenter", name = "###", type = "M", forbidden = {"b","T","t","d","w","a","v","m"} };
--    { class = "VirtualBox", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
--    { class = "rdesktop", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
--    { class = "soulseekqt", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
--    { class = "Wicd-client.py", name = "###", type = "a", forbidden = {"b","d","w","M","v","m"} };
--    { class = "jetbrains-idea-ce", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} }
-- }

config.audio.sinks = {
   analog =
   { 
      speakers = "analog-output-speaker";
      jack = "analog-output-headphones"
   };
   hdmi = "hdmi-output-0";
   bluetooth = "speaker-output"
}

config.network = {}
config.network.interfaces = {
   wifi = "wlp3s0";
   wired = "enp0s25"
}

return config
