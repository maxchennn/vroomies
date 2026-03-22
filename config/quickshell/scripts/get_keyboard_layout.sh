#!/usr/bin/env bash

# Yeah so... this is REALLY bad! This should be refactored at some point!
hyprctl -j devices | grep -B 3 '"main": true' | head --lines=1 | sed 's/^ \+//;s/,$//' | sed 's/"//g' | awk -F ': ' '{ print $2 }'
