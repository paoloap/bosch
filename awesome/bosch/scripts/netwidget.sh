#!/bin/bash

### ---[[  BOSCH NETWIDGET BASH SCRIPT. ]]--- ###
### author: Paolo Porcedda (paoloap|ppaoloapp|schuppenflektor)
### licensed under GPL v3
#
## Dependencies:
#  1. wicd-cli
#  2. ifconfig
#  3. iwconfig
#
## Output:
#  1. Network type (ethernet, wifi, usb): useful to select the icon
#  2. Network status (disconnected, connecting, connected)
#  3. Network interface (wlo1, eno1, enp0s26u1u2...)
#  4. Text to write: ("not connected", "wlo1/wifiAP (75%)", "eno1"...)
#

outputpath="/home/paoloap/.config/awesome/bosch/scripts"

while true; do
  # counting wicd-cli output lines is the simplest way afaik to check the connection status
  wicdlines=`wicd-cli -i | wc -l`
  if  [[ $((wicdlines)) == 1 ]]; then
    status="disconnected"
  elif [[ $((wicdlines)) == 2 ]]; then
    status="connecting"
  else
    # if wicd-cli output lines are 3 or 4
    status="connected"
  fi
  
  
  # check what is wi-fi interface with iwconfig.
  wifiint=`iwconfig 2>/dev/null | cut -d' ' -f1`
  # check what is (eventual) usb tethering interface shown by ifconfig. usually it has a longer name (more than 4 characters).
  usbtint=`ifconfig -a | grep "^[a-z]" | grep -v "^lo:" | cut -d':' -f1 | grep "^.\{5\}"`
  
  if [[ "$status" == "connected" ]]; then
    # find interface name with ifconfig (it's the one with "broadcast" written in the line below)
    interface=`ifconfig | grep -B1 broadcast | cut -d':' -f1 | head -1`
    # if connected interface is wi-fi one, then we want to know also access point name and signal quality
    if [[ "$interface" == "$wifiint" ]]; then
      nettype="wifi"
      # access point name with iwconfig
      ap=`iwconfig 2>/dev/null | grep ESSID | cut -d'"' -f2`
      # to have quality (in %) we make a simple calculation basing on iwconfig "Link Quality"
      let quality="100*"`iwconfig 2>/dev/null | grep "Link Quality" | sed -r 's|^.*Link Quality=([0-9]*/[0-9]*).*$|\1|'`
      text="$interface/$ap ($quality%)"
    else
      if [[ "$interface" == "$usbtint" ]]; then
        nettype="usb"
      else
        nettype="ethernet"
      fi
      text="$interface"
    fi
  
  elif [[ "$status" == "connecting" ]]; then
    # we need to know if there's an usb tethering interface shown by ifconfig. usually it has a longer name (more than 4 characters)
    # now we need to know how many are the interfaces shown by ifconfig with "RUNNING" flag
    runningif=`ifconfig | grep RUNNING | grep -v "^lo" | wc -l`
    # if there are more than one "RUNNING" interfaces, then we can assume that one of them is the usb tethering one, and that the one connecting is the other one. so, let's exclude the usb interface.
    if [[ $((runningif )) > 1 ]]; then
      exclude=${usbtint}
    # else, if there's only one "RUNNING" interface, then it's sure connecting (even if it's the usb tethering one)
    else
      # i put a non-existing string so that nothing is in fact excluded
      exclude="^nononono"
    fi
    interface=`ifconfig | grep RUNNING | grep -v "^lo" | grep -v "$exclude" | cut -d':' -f1`
  
    #if connecting  interface is wi-fi one, then we want to know also access point name
    if [[ "$interface" == "$wifiint" ]]; then
      nettype="wifi"
      ap=`iwconfig 2>/dev/null | grep ESSID | cut -d'"' -f2`
      text="$interface/$ap"
    else
      if [[ "$interface" == "$usbtint" ]]; then
        nettype="usb"
      else
        nettype="ethernet"
      fi
      text="$interface"
    fi
  # only remaining case is "disconnected" one
  else
    text="not connected"
    interface="nothing"
    nettype="nothing"
  fi
  
  echo "$nettype" > "$outputpath"/net_data
  echo "$status" >> "$outputpath"/net_data
  echo "$interface" >> "$outputpath"/net_data
  echo "$text" >> "$outputpath"/net_data
  sleep 1
done
