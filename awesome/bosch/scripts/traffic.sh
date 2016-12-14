#!/bin/bash

### ---[[ BOSCH TRAFFIC WIDGET BASH SCRIPT. ]]--- ###
### author: Paolo Porcedda (paoloap|ppaoloapp|schuppenflektor)
### licensed under GPL v3
#
## Output:
#  1. Download speed in kB/s
#  2. Upload speed in kB/s

outputpath="/home/paoloap/.config/awesome/bosch/scripts"
while true; do 
  interface=`ifconfig | grep -B1 broadcast | cut -d":" -f1 | head -1`
  if [[ -z "$interface" ]]; then
    sleep 1
    echo "0,0" > "$outputpath"/traffic_data
    echo "0,0" >> "$outputpath"/traffic_data
  else
    # take interface line for /proc/net/dev, two times with 1 sec delay
    startcheck=`cat /proc/net/dev | grep "$interface"`
    sleep 1
    endcheck=`cat /proc/net/dev | grep "$interface"`
    
    # extract downloaded and uploaded bytes from the two checks above
    d1=`echo "$startcheck" | awk '{print $2}'`
    d2=`echo "$endcheck" | awk '{print $2}'`
    u1=`echo "$startcheck" | awk '{print $10}'`
    u2=`echo "$endcheck" | awk '{print $10}'`
    
    # transform data in KB/s * 10 (because bash doesn't support floating point)
    let download=(d2-d1)*10/1024
    let upload=(u2-u1)*10/1024
    
    # edit data using sed and show it in KB/s with one number after point
    echo "$download" | sed -r 's/([0-9])$/,1/' | sed 's/^,/0,/' > "$outputpath"/traffic_data
    echo "$upload" | sed -r 's/([0-9])$/,\1/' | sed 's/^,/0,/' >> "$outputpath"/traffic_data
  fi
done
