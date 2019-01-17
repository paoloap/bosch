#!/bin/bash

##############################################
###                                        ###
###  ----------[[ screens.sh ]]----------  ###
###  licensed under GPL v3                 ###
###  Copyright © 2016 Paolo Porcedda       ###
###  porcedda(a)gmail(dot)com              ###
###  paoloap|ppaoloapp|schuppenflektor     ###
###                                        ###
##############################################

# hdmi_sound_toggle function: if an hdmi display is connected, set hdmi as sound output
hdmi_sound_toggle() {
  USER_NAME=`who | grep "(:0)" | cut -d' ' -f1`
  USER_ID=`id -u $USER_NAME`
  HDMI_STATUS=`cat /sys/class/drm/card0/*HDMI*/status`

  export PULSE_SERVER="unix:/run/user/"$USER_ID"/pulse/native"

  if [[ "$HDMI_STATUS" == "connected" ]]; then
    pactl --server $PULSE_SERVER set-card-profile 0 output:hdmi-stereo+input:analog-stereo
  else
    pactl --server $PULSE_SERVER set-card-profile 0 output:analog-stereo+input:analog-stereo
  fi
}

# previously starts as false. it sets to true if during previous cycle a secondary screen was connected
previously=false

while true; do
  # interfaces will keep, separated by spaces, all the available secondary display interfaces
  interfaces=`ls -l /sys/class/drm/card0/ | grep ^drwx | sed -r 's/^.* card0-([A-Z]*)-.*$/\1/' | grep -v ^drwx | grep -v LVDS | tr '\n' ' '`
  # anyconnected starts as false. it sets to true if a secondary screen is actually connected
  anyconnected=false
  interface=""
  # check if any of available display interfaces is connected (eventually set anyconnected to true)
  for i in $interfaces; do
    if [[ `cat /sys/class/drm/card0/*"$i"*/status` == "connected" ]]; then
      anyconnected=true
      break
    fi
  done
  # if a display has been connected/disconnected (if anyconnected and previously are different), there's something to do
  if [[ "$anyconnected" != "$previously" ]] ; then
    # if a display has been connected, put it "above" main screen (and set previously to true!)
    if $anyconnected ; then
      xrandr=`xrandr`
      interface="$(echo "$xrandr" | sed -r 's/^[ ]*//' | grep "^[A-Z]*[1-9] connected" | grep  -v "^LVDS1" | cut -d' ' -f1)"
      selected="$(echo "$xrandr" | grep -A3 "$interface" | grep -v "$interface")"
      interpolated="$(echo "$selected" | head -1 | grep "[0-9]*x[0-9]*i")"
      if [[ ! -z "$interpolated" ]]; then
	excluded="$(echo "$interpolated" | sed -r 's/[ ]*([0-9]+x[0-9]+)i.*/\1/')"
	resolution="$(echo "$selected" | grep -v "$excluded" | head -1 | sed -r 's/[ ]*([0-9]*x[0-9]*).*/\1/' | sed -r 's|^[ ]*([0-9]*x[0-9]*).*$|\1|')"
      else
	resolution="$(echo "$selected" | head -1 | sed -r 's/[ ]*([0-9]*x[0-9]*).*/\1/')"
      fi
      xrandr --output "$interface" --mode "$resolution" --above LVDS1
      previously=true
    # else reset xrandr so that we come back to one-monitor situation (and of course set previously to false)
    else
      xrandr --auto
      previously=false
    fi
    # in any case, if a display has been connected/disconnected, wait 2 seconds, restart awesome and...
    sleep 2; echo -e 'awesome.restart()' | awesome-client
    # ... launch hdmi_sound_toggle function
    hdmi_sound_toggle
  else
    # repeat the loop every 3 secs
    sleep 3
  fi
done

