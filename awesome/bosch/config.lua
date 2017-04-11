---------------------------------------------------------------------------
--- BOSCH - config.lua
--- Configuration file. Here user can set every customizable value
-- Released under GPL v3
-- To do: Comments
-- @author schuppenflektor
-- @copyright 2016 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.6
---------------------------------------------------------------------------

local awful = require("awful")

config = {
    tiling = {};
    bwibox = {}
  }

config.dir = awful.util.getdir("config")
config.bosch = config.dir .. "bosch"
config.theme = config.bosch .. "/theme.lua"
config.pics = config.bosch .. "/pics"
config.scripts = config.bosch .. "/scripts"
config.mail = config.dir .. "../../.mail/inbox"
config.terminal = "termite"
config.editor = "vim"
config.launch_in_term = config.terminal .. " -e "
config.editor_cmd = config.launch_in_term .. config.editor

-- THEME OPTIONS

config.skin = "autumn";
-- font
config.font = "Share Tech Mono 10";
-- colors
config.transparent = "#00000000";
config.colorfg = "#373b41";
config.colorbg = "#f0f0f0";
config.color00 = "#1d1f21";
config.color01 = "#b75b5b";
config.color02 = "#919753";
config.color03 = "#be9c5c";
config.color04 = "#22ad93";
config.color05 = "#9d83a5";
config.color06 = "#729d97";
config.color07 = "#a7aaa8";
config.color08 = "#808280";
config.color09 = "#b75b5b";
config.color10 = "#919753";
config.color11 = "#be9c5c";
config.color12 = "#22ad93";
config.color13 = "#9d83a5";
config.color14 = "#729d97";
config.color15 = "#1d1f21";
-- margins and borders
config.gap = "5";
config.border = "0";
config.border_max = "0";
config.border_switcher = "0";

-- COMMAND OPTIONS

config.commands = {
  terminal = "termite";
  filemanager = "pcmanfm";
  browser = "nuvimb";
  tiledbrowser = "tiledvimb";
  netmanager = "termite -e wicd-curses -t wicd";
  torrent = "termite -e transmission-remote-cli";
  music = "termite -e ncmpcpp";
  lockscreen = config.scripts .. "/lockscreen.sh"; -- depends on i3lock
  screenshot = config.scripts .. "/screenshot.sh 0 0 png"; -- depends on imagemagick
  brightdown = "xbacklight -dec 15";
  brightup = "xbacklight -inc 15";
  voldown = "pulseaudio-ctl down";
  volup = "pulseaudio-ctl up";
  voltoggle = "pulseaudio-ctl mute";
  musicplay = "mpc-pause";
  musicprev = "mpc prev";
  musicnext = "mpc next"
}

-- TILING OPTIONS

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

config.tiling.clients = {
  { class = "Termite", name = "ncmpcpp", type = "m", forbidden = {"b","T","d","t","w","M","a","v"} };
  { class = "Termite", name = "wicd", type = "a", forbidden = {"b","d","t","M","v","m"} };
  { class = "Termite", name = "rtv", type = "t", forbidden = {"b","d","w","M","v","m"} };
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
  { class = "Vlc", name = "###", type = "v", forbidden = {"b","d","M","m"} };
  { class = "Pcmanfm", name = "###", type = "T", forbidden = {"b","d","M","m"} };
  { class = "Chromium", name = "###", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
  { class = "brave", name = "###", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
  { class = "google-chrome", name = "###", type = "b", forbidden = {"T","d","w","a","M","v","m"} };
  { class = "Sxiv", name = "###", type = "d", forbidden = {"b","w","M","v","m"} };
  { class = "Gimp", name = "###", type = "M", forbidden = {"b","T","d","w","a","v","m"} };
  { class = "libreoffice-writer", name = "###", type = "M", forbidden = {"b","T","d","w","a","v","m"} };
  { class = "libreoffice-calc", name = "###", type = "M", forbidden = {"b","T","d","w","a","v","m"} };
  { class = "libreoffice-startcenter", name = "###", type = "M", forbidden = {"b","T","d","w","a","v","m"} };
  { class = "VirtualBox", name = "###", type = "M", forbidden = {"b","T","d","w","a","v","m"} };
  { class = "rdesktop", name = "###", type = "M", forbidden = {"b","T","d","w","a","v","m"} };
  { class = "soulseekqt", name = "###", type = "M", forbidden = {"b","T","d","w","a","v","m"} };
  { class = "Wicd-client.py", name = "###", type = "a", forbidden = {"b","d","w","M","v","m"} }
}

return config
