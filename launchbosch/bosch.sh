#!/bin/bash

### ---[[ BOSCH BWIBOX BASH SCRIPT. ]]--- ###
### author: Paolo Porcedda (paoloap|ppaoloapp|schuppenflektor)
### licensed under GPL v3
#
## The script simply launches all the scripts needed for bwibox widgets

killall mpdwidget.sh
killall netwidget.sh
killall traffic.sh
killall volumewidget.sh
killall batterywidget.sh

outputpath="/home/paoloap/.config/awesome/bosch/scripts"

exec "$outputpath"/mpdwidget.sh & exec "$outputpath"/traffic.sh & exec "$outputpath"/netwidget.sh & exec "$outputpath"/volumewidget.sh & exec "$outputpath"/batterywidget.sh


