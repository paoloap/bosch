#!/bin/bash
import -window root /tmp/screen.png
mogrify -blur 0x5 /tmp/screen.png
i3lock -i /tmp/screen.png
