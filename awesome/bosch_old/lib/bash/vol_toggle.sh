#!/bin/bash
pactl set-sink-mute `pacmd list-sinks| grep '* index' | sed 's/^.*index: //'` toggle
