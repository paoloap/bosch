#!/bin/bash
## Script to instantly produce a screenshot.
## It works well and it supports a secondary screen, but it can be improved...

# Main display geometry
main="$(xrandr | grep eDP1 | cut -d' ' -f4)"

# Second display geometry
sec="$(xrandr | grep ' connected' | sed -n 2p | cut -d' ' -f4)"

echo $main
echo $sec

# Actual date
date="$(date +%Y%m%d%H%M%S)"

# Choose display
if [[ $1 == "1" ]]; then
  mon=$main
elif [[ $1 == "2" ]]; then
  mon=$sec
else
  mon="0"
fi

pause=$2
format=$3
quality=$4

if [[ $format == "jpg" ]]; then
  import -window root -pause $pause -quality $quality tmp."$format"
else
  import -window root -pause $pause tmp."$format"
fi

sleep $pause
sleep 0.4
if [[ $mon == "0" ]]; then
  if [[ ! -z "$sec" ]]; then
    convert tmp."$format" -crop $main ~/dcim/screenshots/ss_"$date"_1."$format"
    convert tmp."$format" -crop $sec ~/dcim/screenshots/ss_"$date"_2."$format"
  else
    cp tmp."$format" ~/dcim/screenshots/ss_"$date"."$format"
  fi
else
  convert tmp."$format" -crop $mon ~/dcim/screenshots/ss_"$date"."$format"
fi
rm tmp."$format"

