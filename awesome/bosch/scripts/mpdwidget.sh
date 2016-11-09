#!/bin/bash

data=`echo "status\ncurrentsong" | curl telnet://127.0.0.1:6600 -fsm 1`
state=`echo "$data" | grep "^state: " | cut -d' ' -f2-
artist=`echo "$data" | grep "^Artist: " | cut -d' ' -f2-`
song=`echo "$data" | grep "^Title: " | cut -d' ' -f2-`



