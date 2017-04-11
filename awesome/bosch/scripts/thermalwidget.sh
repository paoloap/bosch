#!/bin/bash

outputpath="/home/paoloap/.config/awesome/bosch/scripts"

while true; do
  acpi -t | cut -d' ' -f4 | cut -d'.' -f1 > "$outputpath"/thermal_data
  sleep 7
done
