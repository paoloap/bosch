# bosch
Awesome WM 'Bosch Theme'
v 0.4

... yes, the theme is called 'Bosch' despite the actual wallpaper is by Caravaggio. But I still have some Bosch paintings in wallpaper folder :P

In this git I will upload all the configuration files that make my GUI work properly.
This GUI configuration is intended to be as much as lightweight I can, and to maximize keyboard/automation and minimize mouse/touchpad use.

This stuff is still bad developed, all is strongly coupled, and I discourage to adopt it for now, if you like some ideas just try to copy them :)
Sorry for that, I'm learning Lua *while* doing it

NEW STUFF:
- added a color palette
- added ncmpcpp and termite config files
- the awesome files now are compatible (only?) with awesome git/dev version
- started decoupling some functions
- added gap for maximized windows
- some corrections here and there

TODO:
- let only wibox transparent (fix notifications, fix/delete second wibox)
- continue separating functions from rc.lua
- give coherence to keybindings, rules and signals
- decrease coupling using a config.lua file
- create script to select palette on theme (which affects theme.lua, termite-config, gtk theme with oomox-cli, awesome and gtk icons with imagemagick)


I adopt the following:
- Arch
- 'awesome' window manager (with some libraries, including 'vicious' and 'lain-git'. See awesome/rc.lua for more details
- 'oomox-early_bird' gtk3 theme -> https://github.com/actionless/oomox
- 'area o.43' gtk icon theme -> http://gnome-look.org/content/show.php/area.o43+SVG+Icon+theme?content=101979
- 'termite' terminal emulator
- 'vimb' web browser
- 'mpd' music server
- 'ncmpcpp' mpd client
- 'pcmanfm' xorg file manager
- 'turses' ncurses twitter client
- 'rtv' ncurses reddit client
- 'toxic' ncurses tox chat client
- 'vlc' video player
- 'hangups' ncurses chat hangout client
- 'transmission-remote-cli' ncurses torrent client
- 'acpi' for notebook power saving purposes
- 'pulseaudio' audio server
- 'pulsemixer' ncurses pulseaudio volume control manager
- 'sxiv' as pics viewer
- 'zsh' as shell
- 'vim' (of course!) as text editor
- 'lightdm' as session manager (and lockscreen)
- 'taskwarrior' / 'timewarrior' to manage my tasks
- ...some other stuff that I don't remember now :) and various little scripts to automatize

# some screenshots
Empty screen
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/empty.jpg)

Browser start page
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/vimb_max.jpg)

On the left, a vimb session using a profile with "safari mobile" as web agent, so that i can enjoy contents from mobile websites versions in a "tiled" window. On the right, a 'task calendar' and a 'curl wttr.in/Rome'
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/misc.jpg)

Two ncmpcpp terminal sessions to view music playlist and visualizer
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/ncmpcpp.jpg)

Three 'vimb-tiled' sessions
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/vimb_tiled.jpg)

