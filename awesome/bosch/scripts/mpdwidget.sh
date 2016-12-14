#!/bin/bash

### ---[[ BOSCH MPD WIDGET BASH SCRIPT. ]]--- ###
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
  data=`echo -e "status\ncurrentsong\nclose" | curl telnet://127.0.0.1:6600 -fsm 1`
  echo "$data" | grep -e "^state: " -e  "^Artist: " -e "^Title: " | cut -d' ' -f2- > "$outputpath"/mpd_data
  sleep 1
done

