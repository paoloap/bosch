---------------------------------------------------------------------------
--- BOSCH - conf.lua
--- Configuration file. Here user can set every customizable value
-- Released under GPL v3
-- @author schuppenflektor
-- @copyright 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
-- @release 0.8.1
---------------------------------------------------------------------------

local gears = require("gears")
local awful = require("awful")
local lain = require("lain")

conf                    = {}

conf.basekeys           =
{
   mod                  = "Mod4";
   shi                  = "Shift";
   ctl                  = "Control";
   alt                  = "Alt";
}

conf.dir                =
{
   bosch                = gears.filesystem.get_xdg_config_home() .. "bosch/";
   lib                  = gears.filesystem.get_xdg_config_home() .. "bosch/lib/";
   bash                 = gears.filesystem.get_xdg_config_home() .. "bosch/lib/bash/";
   icons                = gears.filesystem.get_xdg_config_home() .. "bosch/media/icons/";
   walls                = gears.filesystem.get_xdg_config_home() .. "bosch/media/wallpapers/";
   cache                = gears.filesystem.get_xdg_config_home() .. "bosch/.cache/";
}

conf.skin               =
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

-- Set the basekeys as short local variables to improve readability into conf.shortcuts table
local mod, shi, ctl, alt = conf.basekeys.mod, conf.basekeys.shi, conf.basekeys.ctl, conf.basekeys.alt
conf.shortcuts          =
{
   terminal             =
   {
      keys              = { mod, "e" };
      spawn             = "termite"
   };
   filemanager          =
   {
      keys              = { mod, shi, "e" };
      spawn             = "thunar"
   };
   browser              =
   {
      keys              = { mod, "g" };
      spawn             = conf.dir.bash .. "browser.sh default";
   };
   tiledbrowser         =
   {
      spawn             = conf.dir.bash .. "browser.sh mobile";
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
      keys              = { mod, "F5" }
      launch            = "xbacklight -dec 15";
   };
   brightup             =
   {
      keys              = { mod, "F6" }
      launch            = "xbacklight -inc 15";
   };
   voldown              =
   {
      keys              = { "F2" }
      launch            = "pactl -- set-sink-volume `pacmd list-sinks| grep '* index' | sed 's/^.*index: //'` -5%";
      signals           = { "widle.pulse" }
   };
   volup                =
   {
      keys              = { "F3" }
      launch            = "pactl -- set-sink-volume `pacmd list-sinks| grep '* index' | sed 's/^.*index: //'` +5%";
      signals           = { "widle.pulse" }
   };
   voltoggle            =
   {
      keys              = { "F3" }
      launch            = "pactl set-sink-mute `pacmd list-sinks| grep '* index' | sed 's/^.*index: //'` toggle";
      signals           = { "widle.pulse" }
   };
   sinkchange           =
   {
      keys              = { mod, "F1" }
      launch            = conf.dir.bash .. "/change_default_sink.sh";
      signals           = { "widle.pulse" }
   };
   musicplay            =
   {
      launch            = "mpc-pause";
      signals           = { "widle.mpd" }
   };
   musicprev            =
   {
      launch            = "mpc prev";
      signals           = { "widle.mpd" }
   };
   musicnext            =
   {
      launch            = "mpc next";
      signals           = { "widle.mpd" }
   };
}


conf.wible              =
{

   --[[

   wible_example       =
   {
      refresh_time      -> an integer which represents the refresh time that will be set to the
                           widgets, in seconds
      model             -> table which represents the data model you want to match with the
                           retrieved data. In general, you can just store it as a strings array,
                           but it's better to think it to make data matching simpler
      icons             -> a table which collects the view strings/media that will be shown
                           in the widgets. In general, you can just store it as an array, but it's
                           better to think it to make widget updating simpler
      command           -> the command that will retrieve the needed data from operating system
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
               speakers = boschdir.dirs.icons .. "audio/analog_speakers_on.png";
               jack     = boschdir.dirs.icons .. "audio/analog_jack_on.png";
            };
            off         =
            {
               speakers = boschdir.dirs.icons .. "audio/analog_speakers_off.png";
               jack     = boschdir.dirs.icons .. "audio/analog_jack_off.png";
            };
         };
         hdmi           =
         {
            on          = boschdir.dirs.icons .. "audio/hdmi_on.png";
            off         = boschdir.dirs.icons .. "audio/hdmi_off.png";
         };
         bluetooth      =
         {
            on          = boschdir.dirs.icons .. "audio/bluetooth_on.png";
            off         = boschdir.dirs.icons .. "audio/bluetooth_off.png";
         };
      };
      command           = 
   };
}

conf.network = {}
conf.network.interfaces = {
   wifi = "wlp3s0";
   wired = "enp0s25"
   }
}


return config
