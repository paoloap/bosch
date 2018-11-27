---------------------------------------------------------------------------
--- BOSCH - config.lua
--- Configuration file. Here user can set every customizable value
-- Released under GPL v3
-- @author schuppenflektor
-- @copyright 2016-2018 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.7
---------------------------------------------------------------------------

local awful = require("awful")
local lain = require("lain")

config = {
	tiling = {};
	bwibox = {}
}


config.dir              = awful.util.getdir("config")
config.bosch	            = config.dir .. "bosch"
config.theme	            = config.bosch .. "/theme.lua"
config.pics             = config.bosch .. "/pics"
config.scripts          = config.bosch .. "/scripts"
config.mail             = config.dir .. "../../.mail/inbox"
-- probably config.terminal and config.editor are not mandatory...
config.terminal	         = "termite"
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
  voldown               = "pulseaudio-ctl down";
  volup                 = "pulseaudio-ctl up";
  voltoggle             = "pulseaudio-ctl mute";
  musicplay             = "mpc-pause";
  musicprev             = "mpc prev";
  musicnext             = "mpc next"
}

-- TILING OPTIONS

-- tiling.tags: an array which represents all possible tag types
-- tags[x].type: x tag's default layout
-- tags[x].name: x tag name
-- tags[x].icon: x tag icon
-- tags[x].key: used to refer to x tag from tiling.clients array's elements

config.tiling.tags = {
   {
   type = "maximized";
   name = "browser";
   icon = config.pics .. "/tags/browser.png";
   key = "b"
   },
   {
   type = "tiling1";
   icon = config.pics .. "/tags/geek.png";
   name = "geek";
   key = "T"
   },
   {
   type = "write";
   name = "distraction-free";
   icon = config.pics .. "/tags/write.png";
   key = "d"
   },
   {
   type = "tiling3";
   name = "chat";
   icon = config.pics .. "/tags/chat.png";
   key = "t"
   },
   {
   type = "tiling1";
   name = "work";
   icon = config.pics .. "/tags/work.png";
   key = "w"
   },
   {
   type = "maximized";
   name = "max-apps";
   icon = config.pics .. "/tags/guis.png";
   key = "M"
   },
   {
   type = "tiling1";
   name = "admin";
   icon = config.pics .. "/tags/admin.png";
   key = "a"
   },
   {
   type = "video";
   name = "video";
   icon = config.pics .. "/tags/show.png";
   key = "v"
   },
   {
   type = "music";
   name = "music";
   icon = config.pics .. "/tags/music.png";
   key = "m"
   }
}

-- tiling.schemes: a set which contains all tag containers.
-- Every scheme is an array of tiling.tags elements
-- You can create your own schemes, which usually apply to a display you use. I created the following three:
-- default: for my laptop's display
-- vga: for an evenutal vga external monitor
-- hdmi: for my tv
config.tiling.schemes = {
   default = {};
   vga = {};
   hdmi = {}
}
config.tiling.schemes = {
   default =  config.tiling.tags;
   vga = {                       
      config.tiling.tags[5],      
      config.tiling.tags[8],
      config.tiling.tags[6]
   };
   hdmi = {
      config.tiling.tags[8],
      config.tiling.tags[9]
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
   { class = "Termite", name = "ncmpcpp", type = "m", forbidden = {"b","T","d","t","w","M","a","v"} };
   { class = "Termite", name = "wicd", type = "a", forbidden = {"b","d","t","M","v","m"} };
   { class = "Termite", name = "rtv", type = "t", forbidden = {"b","d","w","M","v","m"} };
   { class = "TelegramDesktop", name = "###", type = "t", forbidden = {"b","d","w","M","v","m"} };
   { class = "Termite", name = "htop", type = "a", forbidden = {"b","M","v","m"} };
   { class = "Termite", name = "pacaur", type = "a", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "sudo pacman", type = "a", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "yaourt", type = "a", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "root", type = "a", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "ranger", type = "t", forbidden = {"b","M","v","m"} };
   { class = "Termite", name = "hangups", type = "t", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "newsbeuter", type = "t", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "turses", type = "t", forbidden = {"b","d","M","v","m"} };
   { class = "Termite", name = "mutt", type = "w", forbidden = {"b","M","v","m"} };
   { class = "Termite", name = "###", type = "T", forbidden = {"b","M"} };
   { class = "Vimb", name = "vimb-main", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
   { class = "Vimb", name = "vimb-tiled", type = "t", forbidden = {"b","M","v","m"} };
   { class = "vlc", name = "###", type = "v", forbidden = {"b","d","M","m"} };
   { class = "Pavucontrol", name = "###", type = "v", forbidden = {"b","d","M","m"} };
   { class = "Thunar", name = "###", type = "T", forbidden = {"b","d","M","m"} };
   { class = "Chromium", name = "###", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
   { class = "Firefox", name = "###", type = "b", forbidden = {"T","d","t","w","a","M","v","m"} };
   { class = "brave", name = "###", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
   { class = "google-chrome", name = "###", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
   { class = "Sxiv", name = "###", type = "d", forbidden = {"b","w","M","v","m"} };
   { class = "Gimp-2.10", name = "###", type = "M", forbidden = {"b","T","d","w","a","v","m"} };
   { class = "libreoffice-writer", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
   { class = "libreoffice-calc", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
   { class = "libreoffice-startcenter", name = "###", type = "M", forbidden = {"b","T","t","d","w","a","v","m"} };
   { class = "VirtualBox", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
   { class = "rdesktop", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
   { class = "soulseekqt", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} };
   { class = "Wicd-client.py", name = "###", type = "a", forbidden = {"b","d","w","M","v","m"} };
   { class = "jetbrains-idea-ce", name = "###", type = "M", forbidden = {"b","T","d","t","w","a","v","m"} }
}


return config
