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
-- local functions = require("bosch.utils.functions")
config                  =
{
}

config.main_dir         = awful.util.getdir("config") .. "bosch/"
config.theme_dir        = config.bosch .. "theme.lua/"
config.pics_dir         = config.bosch .. "pics/"
config.scripts_dir      = config.bosch .. "scripts/"
config.tmp_dir          = config.bosch .. ".cache/"
config.mod              = "Mod4"
config.shift            = "Shift"
config.ctrl             = "Control"
config.alt              = "Alt"

config.skin             =
{
   font                 = "Share Tech Mono 10";
   transparent          = "#00000000";
   colorfg              = "#373b41";
   colorbg              = "#f0f0f0";
   color00              = "#1d1f21";
   color01              = "#ff49c0";
   color02              = "#00f0c8";
   color03              = "#ff49c0";
   color04              = "#00f0c8";
   color05              = "#ff49c0";
   color06              = "#00f0c8";
   color07              = "#6c6e6d";
   color08              = "#b0b2b0";
   color09              = "#ff49c0";
   color10              = "#00c1a1";
   color11              = "#ff49c0";
   color12              = "#00c1a1";
   color13              = "#ff49c0";
   color14              = "#729d97";
   color15              = "#1d1f21";
   gap                  = "8";
   border               = "2";
   border_max           = "2";
   border_switcher      = "2"
}

local mod, shift, control, alt = config.mod, config.shift, config.control, config.alt
config.shortcuts        =
{
   terminal             =
   {
      keys              = { mod, "e" };
      spawn             = "termite"
   };
   filemanager          =
   {
      keys              = { mod, shift, "e" };
      spawn             = "thunar"
   };
   browser              =
   {
      spawn             = "browser.sh default";
   };
   tiledbrowser         =
   {
      spawn             = "browser.sh mobile";
   };
   torrent              =
   {
      spawn             = "termite -e transmission-remote-cli";
   };
   music_player         =
   {
      spawn             = "termite -e ncmpcpp";
   };
   lock_screen          =
   {
      keys              = { mod, "l" }
      spawn             = "lockscreen.sh";
   };
   screenshot           =
   {
      keys              = { "Print" }
      spawn             = "screenshot.sh 0 0 png";
   };
   screenrec            =
   {
      launch            = "screenrec.sh 10";
   };
   brightdown           =
   {
      launch            = "screenrec.sh 10";
   };
   brightup            =
   {
      launch            = "screenrec.sh 10";
   };
   voldown              =
   {
      launch            = "screenrec.sh 10";
   };
   volup                =
   {
      launch            = "screenrec.sh 10";
   };
   brightdown           = "xbacklight -dec 15";
   brightup             = "xbacklight -inc 15";
   voldown              = "pactl -- set-sink-volume `pacmd list-sinks| grep '* index' | sed 's/^.*index: //'` -5%";
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
config.wible            =
{
   --[[

   wible_example       =
   {
      refresh_time      -> an integer which represents the refresh time that will be set to the
                           widgets, in seconds
      model             -> table which represents the data model you want to match with the
                           retrieved data
      icons             -> a table which represents
      command           -> the command that will retrieve the needed data from operating system a
   };

   ]]
   pulse                =
   {
      refresh_time      = 1;
      model             =
      {
         analog         =
         {
            speakers    = "analog-output-speaker";
            jack        = "analog-output-headphones";
         };
         hdmi           = "hdmi-output-0";
         bluetooth      = "speaker-output";
      };
      view              =
      {
         analog         =
         {
            on          =
            {
               speakers = boschdir.pics.icons .. "audio/analog_speakers_on.png";
               jack     = boschdir.pics.icons .. "audio/analog_jack_on.png";
            };
            off         =
            {
               speakers = boschdir.pics.icons .. "audio/analog_speakers_off.png";
               jack     = boschdir.pics.icons .. "audio/analog_jack_off.png";
            };
         };
         hdmi           =
         {
            on          = boschdir.pics.icons .. "audio/hdmi_on.png";
            off         = boschdir.pics.icons .. "audio/hdmi_off.png";
         };
         bluetooth      =
         {
            on          = boschdir.pics.icons .. "audio/bluetooth_on.png";
            off         = boschdir.pics.icons .. "audio/bluetooth_off.png";
         };
      };
   };
}

config.network = {}
config.network.interfaces = {
   wifi = "wlp3s0";
   wired = "enp0s25"
   }
}


return config
