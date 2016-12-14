#!/bin/bash
xrandr --listmonitors | grep -v "^ 0" | sed -r "s/^ 1: \+([^ ]*) .*$/\1/" | sed "s/^Monitors: //"
