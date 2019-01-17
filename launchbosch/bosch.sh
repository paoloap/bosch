#!/bin/bash

### ---[[ BOSCH BWIBOX BASH SCRIPT. ]]--- ###
### author: Paolo Porcedda (paoloap|ppaoloapp|schuppenflektor)
### licensed under GPL v3
#
## The script simply launches all the scripts needed for bwibox widgets


killall thermalwidget.sh
killall batterywidget.sh

outputpath="/home/paoloap/.config/awesome/bosch/scripts"

 exec "$outputpath"/thermalwidget.sh & exec "$outputpath"/batterywidget.sh


