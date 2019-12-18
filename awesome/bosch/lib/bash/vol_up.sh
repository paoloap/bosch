#!/bin/bash
pactl -- set-sink-volume `pacmd list-sinks| grep '* index' | sed 's/^.*index: //'` +5%
