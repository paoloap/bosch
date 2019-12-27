#!/bin/bash
## Script that dinamically generates the image shown on screen lock
import -window root /tmp/screen.png
mogrify -blur 0x5 /tmp/screen.png
convert /tmp/screen.png $HOME/.config/awesome/bosch/pics/other/onlock.png -composite /tmp/locked.png
i3lock -i /tmp/locked.png
