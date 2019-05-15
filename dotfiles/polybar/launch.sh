#!/bin/bash

# Terminating any currently running instances
killall -q polybar

# puase while killall completes
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Launch bar(s)
MONITOR=HDMI-1 polybar example -c /home/sayem/.config/polybar/config &
# polybar top -q &
# polybar bottom -q &

echo "polybars launched"
