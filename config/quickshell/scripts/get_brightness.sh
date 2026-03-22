#!/usr/bin/env bash

if ! brightnessctl get > /dev/null 2>&1; then
    echo "69"
    exit 0
fi

v_get=$(brightnessctl get)
v_max=$(brightnessctl max)

v_get_100=$(( v_get * 100 ))

percentage=$(( v_get_100 / v_max ))

echo "$percentage"
