#!/bin/bash
## Script to record a screen video.
## We need to elaborate a method to stop this whenever we want.
## Moreover, due to some bug, it's not working properly.

# Main display geometry
main="$(xrandr | grep eDP-1 | cut -d' ' -f4 | sed 's/\+.*//')"

# Second display geometry
sec="$(xrandr | grep ' connected' | sed -n 2p | cut -d' ' -f3)"

# Actual date
date="$(date +%Y%m%d%H%M%S)"

ffmpeg -video_size $main -framerate 25 -f x11grab -i :0.0 -f pulse -i default -t $1 ~/dcim/screenshots/sr_"$date".mp4
