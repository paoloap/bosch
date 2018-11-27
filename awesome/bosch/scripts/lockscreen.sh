#!/bin/bash
import -window root /tmp/screen.png
mogrify -blur 0x5 /tmp/screen.png
convert /tmp/screen.png /home/paoloap/.config/awesome/bosch/pics/other/onlock.png onlock.png -composite /tmp/locked.png
i3lock -k --keyhlcolor=00c1a1ff \
	--time-font="Share Tech Mono" \
	--date-font="Share Tech Mono" \
	--datesize=20 \
	--datestr="%a %d/%m/%y" \
	--timecolor=ff49c0ff \
	--datecolor=ff49c0ff \
	--ringcolor=ff49c0ff \
	--ringvercolor=00ffc8ff \
	--ringwrongcolor=d23c9eff \
	--insidecolor=00ffc8ff \
	--indicator \
	-i /tmp/locked.png
