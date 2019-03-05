#!/usr/bin/bash
killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 1; done
polybar i3 &
echo "Bars launched..."
