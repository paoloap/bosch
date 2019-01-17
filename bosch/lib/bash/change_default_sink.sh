#!/usr/bin/env bash

### BOSCH data.sh
### Associated with a key combination, it change default pulsaudio sink
### to the next one (if there are more than one sink connected)
## Released under GPL v3
## Author schuppenflektor
## Copyright (c) 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
## Release 0.8.1

pacmd=`pacmd list-sinks | grep " index: " | cut -c3,12`
defindex=`echo "$pacmd" | grep -n \* | cut -c1`
indexnum=`echo "$pacmd" | wc -l`
newdefnum=`expr $defindex % $indexnum + 1`
pacmd set-default-sink `echo "$pacmd" | head -"$newdefnum" | tail -1`

