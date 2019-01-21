#!/usr/bin/env bash

### BOSCH data.sh
### Bash script which returns data from several sources like pulseaudio,
### mpd, wicd etc, depending on input parameter.
## Released under GPL v3
## Author schuppenflektor
## Copyright (c) 2016-2019 Paolo Porcedda - porcedda(at)gmail.com
## Release 0.8.1

set -o errexit
set -o nounset

case "$1" in
    pulse)
        pacmd list-sinks | sed -r 's/^[ ]*[\t]*//' | grep -e '^volume:' -e '^active port:' -e '^muted: ' -e '^[ \\* ]*index: '
        ;;
    mpd)
        echo -e "status\ncurrentsong\nclose" | curl telnet://127.0.0.1:6600 -fsm 1 | grep -e "^state: " -e "^file: " -e "^Name: " -e "^Title: " -e "^Artist: "
        ;;
    wicd)
        wicd-cli -i
        ;;
    *)
        ;;
esac

