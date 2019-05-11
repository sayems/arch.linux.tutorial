#!/bin/bash

# Terminating any currently running instances
killall -q polybar

# puase while killall completes
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

if type "xrandr" > /dev/null; then
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		MONITOR=$m polybar --reload top -c ~/.config/polybar/config &
	done
else
	polybar --reload top -c ~/.config/polybar/config &
fi

# Launch bar(s)
polybar i3wmthemer_bar -q &
# polybar top -q &
# polybar bottom -q &

echo "polybars launched"

albert &at