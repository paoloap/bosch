#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:/usr/lib32/jvm/default/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/paoloap/.path

export DISPLAY=:0

plural="s"

while true; do
  newmails=`getmail | grep "^[[:space:]]*[0-9]" | sed -r 's/^[ ]*([0-9]*) .*$/\1/'`
  if [[ "$newmails" != "0" ]]; then
    if [[ "$newmails" == "1" ]]; then
      plural=""
    fi
    notify-send "You have $newmails new mail""$plural"
  fi
  sleep "$1"
done
