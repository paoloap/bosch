# bosch

## Bosch AwesomeWM extension, develop branch

### Desired project structure

```
awesome
|
|___rc.lua
|___conf.lua
	
bosch
|___init.lua
|
|___core
|	|___init.lua
|	|
|	|___engine.lua
|	|___makeup.lua
|
|___lib
|	|
|	|___bash
|	|	|
|	|	|___data_fetch.sh
|	|	|___screens.sh
|	|
|	|___lua
|		|
|		|___tricks.lua
|
|___media
|	|
|	|___icons
|	|	|
|	|	|___[icons]
|	|
|	|___other
|	|	|
|	|	|___lock_base.png
|	|	|___login_base.png
|	|
|	|___walls
|		|
|		|__[wallpapers]
|
|___modules
|	|___init.lua
|	|
|	|___layout
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
|	|___wible
|		|___init.lua
|		|
|		|___pulse.lua
|		|___mpd.lua
|		|___wicd.lua
|		|___traffic.lua
|		|___capslock.lua
|	
|___.cache

external
|___bosch_gtk_theme
|	|
|	|___[theme structure]
|
|___bosch_icon_theme
|	|
|	|___[theme structure]
|
|___install_tools
|	|
|	|___generate_conf.sh
|	|___generate_skin.sh
|
|___readme_media
|	|
|	|___[screenshots etc]
|
|___gtk.css
|___ncmpcpp_config
|___share_tech_mono.otf
|___termite_config

launch_bosch.sh
```


