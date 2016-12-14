#!/bin/bash

### ---[[ BOSCH VOLUME WIDGET BASH SCRIPT. ]]--- ###
### author: Paolo Porcedda (paoloap|ppaoloapp|schuppenflektor)
### licensed under GPL v3
#
## Dependencies:
#  1. curl
#  2. mpd
#
## Output:
#  1. Mpd status (play, pause, stop)
#  2. Currently playing song artist
#  3. Currently playing song title

outputpath="/home/paoloap/.config/awesome/bosch/scripts"

while true; do
  pacmd=`pacmd list-sinks`
  echo "$pacmd" | grep "^[[:space:]]*active port:" | sed -r 's|^.*<(.*)>.*$|\1|' > "$outputpath"/volume_data
  echo "$pacmd" | sed -n -e '0,/*/d' -e '/base volume/d' -e '/volume:/p' -e '/muted:/p' | grep muted | cut -d' ' -f2 >> "$outputpath"/volume_data
  echo "$pacmd" | sed -n -e '0,/*/d' -e '/base volume/d' -e '/volume:/p' -e '/muted:/p' | grep volume  | cut -d'/' -f2 | tr -d ' ' >> "$outputpath"/volume_data
  sleep 1
done

