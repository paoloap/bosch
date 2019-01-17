#!/bin/bash
if [[ $1 == 'pulse' ]]; then
    pacmd list-sinks | sed -r 's/^[ ]*[\t]*//' | grep -e '^volume:' -e '^active port:' -e '^muted: ' -e '^[ \\* ]*index: '
fi
