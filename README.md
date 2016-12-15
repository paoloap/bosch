# bosch
Awesome WM 'Bosch Theme'
v 0.6

In this git I will upload all the configuration files that make my GUI work properly.
This GUI configuration is intended to be as much as lightweight I can, and to maximize keyboard/automation and minimize mouse/touchpad use.

While I improved a lot the code and decoupled many things, I still discourage to try to make this work out of the box. It's not perfect in my own pc, probably in other ones just few things will work. If you like it, for now just take inspiration and copy-paste the code parts you're interested in :)

NEW STUFF:

0.6.1
- added scripts to autostart bosch services

0.6
- now the theme in compatible (only?) with awesome git version
- decoupled almost everything
- created a config.lua file
- changed colors and various settings
- added gtk theme (generated with oomox)
- added icon theme (areao43, edited)
- other things that i don't remember...

0.5
- added config part in theme.lua
- rewrited and decoupled all bwibox
- rewrited and decoupled all tiling part (layouts and tags management)

0.4
- added a color palette
- added ncmpcpp and termite config files
- the awesome files now are compatible (only?) with awesome git/dev version
- started decoupling some functions
- added gap for maximized windows
- added a "switcher" to view all non-minimezed windows in a maximized layout (see below)
- fixed notifications
- fixed minimized clients wibox
- some corrections here and there

TODO:
- still a lot of things...

DEPENDENCIES:
- awesomewm 4 (or - in general - git version)
- xrandr
- pulseaudio
- xcompmgr
- maildir (every mail service works only if you have it in maildir format)
- termite
- there are a lot of other dependencies, mainly related to keybindings (pcmanfm, ncmpcpp, zathura...), but i'll try to symbolize every shortcut through config file, so that everyone can adopt bosch with favourite programs. i must say that it's a long-term goal, because i created all this stuff with the purpose of make it work in my personal machine(s): in general at the time i'd rather consider it as a group of Lua/Bash files with the addition of some nice wallpapers and icons, than as a fully working gui.


# some screenshots
Empty screen
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/empty_screen.jpg)

Browser start page
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/vimb_start_page.jpg)

Browser random page
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/vimb_random_page.jpg)

Two vim sessions
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/vim_sessions.jpg)

Three "tiled browser" sessions
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/tiledvimb.jpg)

ncmpcpp
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/ncmpcpp.jpg)

lxappearence, pcmanfm, sxiv
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/gtk.jpg)

Neofetch and htop
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/neofetch_htop.jpg)

The Switcher
![ScreenShot](https://raw.github.com/paoloap/bosch/master/screenshots/switcher.jpg)
