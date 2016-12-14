#!/bin/bash

outputpath="/home/paoloap/.config/awesome/bosch/scripts"

while true; do
  info=`acpi | sed -r 's/^[^:]*: (.*)$/\1/'`
  echo "$info" | cut -d"," -f1 > "$outputpath"/battery_data
  echo "$info" | sed -r 's/^[^,]*, ([0-9]*)%.*$/\1/' >> "$outputpath"/battery_data
  sleep 1
done
