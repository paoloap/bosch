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
|		|______[wallpapers]
|
|_______modules
|	|_______init.lua
|	|
|	|_______layout
|	|	|___init.lua
|	|	|
|	|	|___maximo.lua
|	|	|___normie.lua
|	|
|	|___view
|	|	|___init.lua
|	|	|
|	|	|___bwibox.lua
|	|	|___panoti.lua
|	|	|___clinot.lua
|	|
|	|_______wible
|		|___init.lua
|		|
|		|___pulse.lua
|		|___mpd.lua
|		|___wicd.lua
|		|___traffic.lua
|		|___capslock.lua
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


