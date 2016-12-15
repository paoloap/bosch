#!/bin/bash

killall mailnotify.sh
killall bosch.sh
killall screens.sh

scriptspath="launchbosch"

exec "$scriptspath"/mailnotify.sh 120 & exec "$scriptspath"/screens.sh & exec "$scriptspath"/bosch.sh
