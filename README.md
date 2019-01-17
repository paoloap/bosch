# bosch
Awesome WM 'Bosch Theme'
v 0.8.0

## I have corrected several errors and updated some function. I'm going to create a "develop" branch because 0.9 version will be almost rewritten, all the project will change (not the behaviour, but the programming style, considering that I've improved a lot with Lua). I hope that when I'll finish it will become usable for the most. See you soon

In this git I will upload all the configuration files that make my GUI work properly.
This GUI configuration is intended to be as much as lightweight I can, and to maximize keyboard/automation and minimize mouse/touchpad use.

While I improved a lot the code and decoupled many things, I still discourage to try to make this work out of the box. It's not perfect in my own pc, probably in other ones just few things will work. If you like it, for now just take inspiration and copy-paste the code parts you're interested in :)

# Some screenshots
Empty screen
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/empty.png)

Browser start page (browser tag)
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/startpage.png)

Vim, thunar, zsh/git (nerd tag)
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/nerd.png)

Intellij Idea (maximized tag)
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/maximized.png)

Ncmpcpp (music tag)
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/music.png)


# Various information
## About tiling settings
Dynamic tagging is good, but too freedom in its interpretation risks to traduce into cervellotic ideas and not ergonomic consequences.

- Upstream, some "scenarios" (tag/layout couples) must be defined. By default they are:

```
browsers (maximized) ------------------ brave, firefox, chromium, vimb, opera...
nerd (tiling1-classic) ---------------- termite, thunar...
distraction-free (tiling2-centered) --- termite/vim...
chat (tiling3-columned) --------------- tiled-vimb, termite/hangups...
work (tiling1-classic) ---------------- mutt...
admin (tiling1-classic) --------------- termite/htop, termite/pacman, wicd...
max-apps (maximized) ------------------ libreoffice, gimp, intellij...
video (tiling1-classic) --------------- vlc...
music (tiling2-centered) -------------- nncmpcpp, quodlibet...
```

- By `config.lua` user can create/delete/edit scenarios
- When system is started there's only one open tag, other ones are inactives
- Every time a new client is opened, it can be put into an active tag (possibly the actually selected one) or activate a new one
- Following standard AwesomeWM behaviour, to every tag (activated or not) it's associated a number
- A tag is deactivated when there are no clients in it, and activates when a client is put into it
- Every client has a default tag and a set of forbidden ones. When the client opens, if the actual tag is not forbidden, the client is opened there. If it's forbidden, the client is put into its default tag.
- Actual existing philosophies aren't imo ergonomic: if we just allow to set a default tag, it's ok if we talk about a browser, but many clients don't belong to a specific tag and nevertheless are not made to be opened everywhere (i.e. a GTK application like thunar is ok on some kinds of tiled layouts but not to others)
- Anyway, we can simply "manually" move a client between tags, included forbidden ones, using Super+Shift+[tag number]
- There's a keybind that send every client to its default tag
- A new app by default is not configured. If a client isn't configured, it just open always into actual tag
- Clients can be configured by `config.lua` file.
- Dynamic tagging (intended as dynamically create/edit/remove tags) is not allowed without rules. Anyway it's implemented a keybind which moves a client into a temporary "single-client" tag, which will be "destroyed" when the client is closed/moved

ABOUT TOP BAR (bwibox)
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/bwibox.jpg)
- The top bar should contain only things that user need to see very often.
- So yes to:
```
Actual active tags (with selected tag highlighted)
Focused client's titlebar (no icon, just text)
Active sound output (Speakers, bluetooth, hdmi, jack)
Sound volume
Actual MPD playing song (if yes)
CPU stress
MEM stress
NOTE: 'stress' situations are not implemented yet, because I didn't reprogrammed
  these widget from scratch yet, they are still based on vicious
Battery status/charge
Thermal (needed in my case)
Connection status (wifi, eth, usb, bluetooth, connecting, disconnected, connected)
Traffic (download, upload)
Unread mails
Date/Time
Actual layout
```
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/taglist.jpg)

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/audio.jpg)

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/system.jpg)

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/network.jpg)

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/mail.jpg)

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/clock_layout.jpg)


![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/volume_icons.jpg)

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/system_icons.jpg)

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/network_icons.jpg)

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/mail_icons.jpg)

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/layout_icons.jpg)

- No to:
```
Free disk space
List of windows (in a tiling layout all windows are directly shown so I don't see the
  point, in a maximized layout i added a thing called "switcher", we'll see that later)
```
### TECHNICALLY:
- For every widget there's a bash script which extracts the data from basic unix commands every n seconds, and writes it into plain text files, which consequentially updates
- These scripts and text files are into bosch/scripts directory
- To put the data into the widgets, there are some lua functions into bosch/bwibox directory

## About clients
- Maximize content space. So no titlebar (if we want to see the title, let's just focus to the client and see it in the bwibox), and no borders
- The actual focused client is "signed" with a green line at the bottom

## About switcher
- If we are in a maximized layout, considering what described before, we have a problem about seeing all clients opened in tag.
- That's what switcher is for: if we are into a tag with maximized layout (i.e. browser one), there is a key binding which toggles a general view, and temporary shows the titlebar for every client
Switcher with some browser instances open (browser tag)
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/switcher.png)

## About browser
- The idea is to have a simple, lightweight, button-less, keyboard-driven browser
- Possibly this browser should be also tab-less, because the wm manages correctly the different browser instances, with the help of the switcher, and this way we can maximize space available for websites' content
- The better choice imo is vimb browser: it's simple, it's lightweight, it's button-less, it's tab-less, it's keyboard oriented, and there's a WebKit2 version in development and already usable.
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/browser.png)
- Moreover, it allows to create different "profiles" based on separate configuration files.
- So we can create a separate profile, called "tiled" or "tiledvimb", which has the same configuration of "main" profile, except for one important aspect: we configure "Safari Mobile" as agent. This way, by default every web page will open in "mobile" website version, and it's just perfect for a tiled layout!
- Unfortunately, vimb and in general every tiling-compliant browser has issues. Just two examples: they haven't "mainstream browser" extensions (it's really painful to even have an ad blocker...), and have some problems with some websites (i.e. web.whatsapp.com). My tip is to always have also a "traditional" browser like firefox or chrome, that you can open if needed

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/tiled_browser.png)

## About terminal
- Just like the browser, the terminal should be lightweight, button-less and tab-less
- But it should correctly support colors
- So I choosed termite, which also supports internal padding and pic integration (well, I didn't realize how to make it work yet...)
In spiral layout
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/terminals.png)

## About GTK
- I adopted an icon theme and a color scheme (which matches with termite and awesomewm) both created with oomox
- I adopted as font the same font (Share Tech Mono 10) used for terminal and awesomewm
- I used pcmanfm but now I moved to thunar file manager. Nevertheless it's trivial to adopt your favourite file manager and configure it in Bosch

## About key-shortcuts
I find Awesome WM default key-shortcuts not very comfortable. In my idea all important ones should be one-hand. So this is my custom mapping:

![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/infographic.png)

## About config.lua
In my opinion all custom user settings should be into a unique file, and that's why I created `config.lua`.
- Theming options: you can set the color scheme, the gaps and the borders. Example:
```
config.font = "Share Tech Mono 10";
config.transparent = "#00000000";
config.colorfg = "#373b41";
config.colorbg = "#f0f0f0";
config.color00 = "#1d1f21";
config.color01 = "#b75b5b";
...
config.gap = "5";
config.border = "0";
```
- Command options: you can set all standard commands (like terminal, file manager, browser, volume buttons commands, etc.). Example:
```
config.commands = {
  terminal = "termite";
  filemanager = "thunar";
  browser = "nuvimb";
  tiledbrowser = "tiledvimb";
  netmanager = "termite -e wicd-curses -t wicd";
  torrent = "termite -e transmission-remote-cli";
  music = "termite -e ncmpcpp";
  lockscreen = "dm-tool lock";
  screenshot = "shot 0 0 png";
  brightdown = "xbacklight -dec 15";
  brightup = "xbacklight -inc 15";
  voldown = "pulseaudio-ctl down";
  volup = "pulseaudio-ctl up";
  voltoggle = "pulseaudio-ctl mute";
  musicplay = "mpc-pause";
  musicprev = "mpc prev";
  musicnext = "mpc next"
}
```
Tiling options: this is the most complex part. We have:
- config.tiling.tags: an array with all possible tags. Every one has a layout type (a string which can be: maximized, tiling1 or 2 or 3, write, video, music, floating, fullscreen), a name (which will be not shown), an icon, and a key which univocally identifies the tag. Example:
```
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
}
```
- config.tiling.schemes: a three-elements table, each one is the set of tags which will be set to a different screen type: default is the one used for main display (by default it just inherits config.tiling.tags), vga and hdmi for external connected monitors. It can be useful for people that, like me, use external displays for precise purposes (i.e. I use an HDMI tv, for which I want a "video" tag as first). Example:
```
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
```
- config.tiling.clients: an array which all clients for which we want to apply some dynamic tagging logic. As already stated in "tiling" section, for every client we have class and name variables (to identify it univocally), a type variable (which contains the key of its default tag, and a sub-array named "forbidden", which contains the keys of tags in which we don't want to find them. Example:
```
config.tiling.clients = {
  { class = "Termite", name = "ncmpcpp", type = "m", forbidden = {"b","T","d","t","w","M","a","v"} };
  { class = "Termite", name = "wicd", type = "a", forbidden = {"b","d","t","M","v","m"} };
  { class = "Termite", name = "rtv", type = "t", forbidden = {"b","d","w","M","v","m"} };
  { class = "TelegramDesktop", name = "###", type = "t", forbidden = {"b","d","w","M","v","m"} };
  { class = "Termite", name = "htop", type = "a", forbidden = {"b","M","v","m"} };
  { class = "Termite", name = "pacaur", type = "a", forbidden = {"b","d","M","v","m"} };
}
```

# Release notes
## TO DO:
- Implement "separate client" function
- Pics into terminals
- An app which takes config.lua and export the settings to gtk, icons, terminal etc

## New stuff

### 0.7
- moved keybindings, rules and signal from rc.lua to bosch/krs.lua
- moved theme initialization and error managing from rc.lua to bosch/init.lua
- ordered code
- a lockscreen (based on i3-lock) which simply takes a screenshot of what actually appears, blur it and add some pic on it
- corrected several bugs
- improved code comments
- added xcompmgr autostart to manage some simple effects like shadows
- added caps lock bwibox widget

### 0.6.2
- upgraded dynamic tagging logic
- changed key-shortcuts
- changed appearence, in general
- updated icons
- added thermal widget
- corrected some stuff
- created a lockscreen script (based on i3lock)
- added some documentation on how to set it up

### 0.6.1
- added scripts to autostart bosch services

### 0.6
- now the theme is compatible (only?) with awesome git version
- decoupled almost everything
- created a config.lua file
- changed colors and various settings
- added gtk theme (generated with oomox)
- added icon theme (areao43, edited)
- other things that i don't remember...

### 0.5
- added config part in theme.lua
- rewrited and decoupled all bwibox
- rewrited and decoupled all tiling part (layouts and tags management)

### 0.4
- added a color palette
- added ncmpcpp and termite config files
- the awesome files now are compatible (only?) with awesome git/dev version
- started decoupling some functions
- added gap for maximized windows
- added a "switcher" to view all non-minimezed windows in a maximized layout (see below)
- fixed notifications
- fixed minimized clients wibox
- some corrections here and there

# Installation
## Dependencies:
Some of them are just optional, or repleaceable with other commands
- awesomewm
- xrandr
- acpi
- imagemagick
- pulseaudio
- vimb
- maildir (every mail service works only if you have it in maildir format)
- termite
- i3lock
- mpd
- ncmpcpp
- mpc
- zathura
- thunar
- transmission
- xorg-xbacklight
- zsh

## If you want to try to install it despite everything...
- copy awesome folder in your $HOME/.config/ (remember to backup all your previous awesomewm files before!)
- copy gtk/icons_bosch_areao43 folder in $HOME/.icons/
- copy gtk/theme_bosch_oomox folder in $HOME/.themes/
- copy gtk/gtk.css to $HOME/.config/gtk-3.0/
- copy ncmpcpp-config to $HOME/.ncmpcpp/ and rename it to 'config'
- copy termite-config to $HOME/.config/termite/ and rename it to 'config'
- copy launchbosch folder in... well, whereever you want, but keep track of its path
- edit launchbosch.sh setting $scriptpath with launchbosch folder position
- copy launchbosch.sh to your user path folder
- edit your .xinitrc (or your .xprofile, or whatever) adding 'launchbosch.sh &' at the end of it
