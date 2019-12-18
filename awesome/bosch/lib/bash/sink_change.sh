#!/bin/bash
## Associated with a key combination, it change default pulsaudio sink
## to the next one (if there are more than one sink connected)

pacmd=`pacmd list-sinks | grep " index: " | cut -c3,12`
defindex=`echo "$pacmd" | grep -n \* | cut -c1`
indexnum=`echo "$pacmd" | wc -l`
newdefnum=`expr $defindex % $indexnum + 1`
pacmd set-default-sink `echo "$pacmd" | head -"$newdefnum" | tail -1`

