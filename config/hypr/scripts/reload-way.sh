#!/usr/bin/env sh

pkill -x waybar
while pgrep -x waybar > /dev/null; do sleep 0.1; done
waybar &
