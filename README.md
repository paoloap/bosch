# bosch

## Bosch AwesomeWM extension, develop branch

### Desired project structure

```
awesome
|
|_______rc.lua
|_______conf.lua
	
bosch
|_______init.lua
|
|_______core
|	|_______init.lua
|	|
|	|_______engine.lua
|	|_______makeup.lua
|
|_______lib
|	|
|	|_______bash
|	|	|
|	|	|_______data_fetch.sh
|	|	|_______screens.sh
|	|
|	|_______lua
|		|
|		|_______tricks.lua
|
|_______media
|	|
|	|_______icons
|	|	|
|	|	|_______[icons]
|	|
|	|_______other
|	|	|
|	|	|_______lock_base.png
|	|	|_______login_base.png
|	|
|	|_______walls
|		|
|		|_______[wallpapers]
|
|_______modules
|	|_______init.lua
|	|
|	|_______layout
|	|	|_______init.lua
|	|	|
|	|	|_______maximo.lua
|	|	|_______normie.lua
|	|
|	|_______view
|	|	|_______init.lua
|	|	|
|	|	|_______bwibox.lua
|	|	|_______panoti.lua
|	|	|_______clinot.lua
|	|
|	|_______wible
|		|_______init.lua
|		|
|		|_______pulse.lua
|		|_______mpd.lua
|		|_______wicd.lua
|		|_______traffic.lua
|		|_______capslock.lua
|	
|_______.cache

external
|_______bosch_gtk_theme
|	|
|	|_______[theme structure]
|
|_______bosch_icon_theme
|	|
|	|_______[theme structure]
|
|_______install_tools
|	|
|	|_______generate_conf.sh
|	|_______generate_skin.sh
|
|_______readme_media
|	|
|	|_______[screenshots etc]
|
|_______gtk.css
|_______ncmpcpp_config
|_______share_tech_mono.otf
|_______termite_config

launch_bosch.sh
```


