#!/bin/bash
#
# Shell script to force hibernate and restore sleep mode.

hmode=25 # Suspend to disk mode

case "$1" in
restore)
	bakhmode=$(pmset -g | grep hibernatemode | awk '{print $2}') # Get hibernate mode
	if (( $bakhmode > 0 )); then
		sudo pmset -a hibernatemode 0 # Restore hibernate mode
	fi
	;;
set)
	sudo pmset -a hibernatemode $hmode # Set hibernate mode
	pmset sleepnow
	;;
esac
