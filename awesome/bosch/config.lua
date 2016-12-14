---------------------------------------------------------------------------
--- BOSCH - config.lua
--- Configuration file. Here user can set every customizable value
-- Released under GPL v3
-- To do: Comments
-- @author schuppenflektor
-- @copyright 2016 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.6
---------------------------------------------------------------------------

local naughty = require("naughty")
local beautiful = require("beautiful")
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
-- config.colorfg = "#d3c8a3";
-- config.colorbg = "#100d0a";
-- config.color00 = "#444034";
-- config.color01 = "#5d5747";
-- config.color02 = "#6e6754";
-- config.color03 = "#837b64";
-- config.color04 = "#9a9176";
-- config.color05 = "#b7ad8d";
-- config.color06 = "#c1b895";
-- config.color07 = "#d9cda6";
-- config.color08 = "#a88e70";
-- config.color09 = "#41dbae";
-- config.color10 = "#88a34a";
-- config.color11 = "#ffe1aa";
-- config.color12 = "#b94c3a";
-- config.color13 = "#4f341f";
-- config.color14 = "#b5a752";
-- config.color15 = "#71883e";
-- margins and borders
config.gap = "5";
config.border = "4";
config.border_max = "0";
config.border_switcher = "4";

config.tiling.tags = {
  {
  type = "maximized";
  name = "⚓";
  icon = config.pics .. "/tags/browser.png";
  key = "b"
  },
  {
  type = "tiling1";
  icon = config.pics .. "/tags/geek.png";
  name = "%"
  },
  {
  type = "write";
  name = "¶";
  icon = config.pics .. "/tags/write.png";
  key = "w"
  },
  {
  type = "tiling1";
  name = "♥";
  icon = config.pics .. "/tags/chat.png";
  key = "t"
  },
  {
  type = "tiling1";
  name = "⚒";
  icon = config.pics .. "/tags/work.png";
  key = "work"
  },
  {
  type = "maximized";
  name = "⌘";
  icon = config.pics .. "/tags/guis.png";
  key = "M"
  },
  {
  type = "tiling1";
  name = "#";
  icon = config.pics .. "/tags/admin.png";
  key = "a"
  },
  {
  type = "video";
  name = "❏";
  icon = config.pics .. "/tags/show.png";
  key = "v"
  },
  {
  type = "music";
  name = "♬";
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
  { class = "Termite", name = "mpd-player", type = "m" };
  { class = "Termite", name = "write", type = "w" };
  { class = "Termite", name = "rtv", type = "t" };
  { class = "Termite", name = "htop", type = "a" };
  { class = "Termite", name = "pacaur", type = "a" };
  { class = "Termite", name = "sudo pacman", type = "a" };
  { class = "Termite", name = "yaourt", type = "a" };
  { class = "Termite", name = "root", type = "a" };
  { class = "Termite", name = "ranger", type = "t" };
  { class = "Termite", name = "hangups", type = "t" };
  { class = "Termite", name = "mutt", type = "work" };
  { class = "Vimb", name = "vimb-main", type = "b" };
  { class = "Vimb", name = "vimb-tiled", type = "t" };
  { class = "Vlc", name = "###", type = "v" };
  { class = "Chromium", name = "###", type = "b" };
  { class = "Sxiv", name = "###", type = "t" };
  { class = "Gimp", name = "###", type = "M" };
  { class = "VirtualBox", name = "###", type = "M" };
  { class = "rdesktop", name = "###", type = "M" };
  { class = "soulseekqt", name = "###", type = "M" };
  { class = "Wicd-client.py", name = "###", type = "a" }
}



return config
