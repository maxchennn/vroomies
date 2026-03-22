#!/usr/bin/env bash

shader="$1"

current_shader="$(hyprctl getoption decoration:screen_shader | grep '^str' | sed 's/^str: //')"
current_shader="$(basename "$current_shader" | sed 's/\.glsl$//')"

if [[ "$current_shader" == "$shader" ]]; then
    echo "YES"
else
    echo "NO"
fi
