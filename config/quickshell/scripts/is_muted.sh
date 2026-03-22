#!/usr/bin/env bash

SINK_SOURCE=""
sink_source=""
if [[ "$1" == "speaker" ]]; then
    SINK_SOURCE="SINK"
    sink_source="sink"
elif [[ "$1" == "mic" ]]; then
    SINK_SOURCE="SOURCE"
    sink_source="source"
else
    exit 1
fi

is_muted="$(pactl get-${sink_source}-mute @DEFAULT_${SINK_SOURCE}@ | cut -f2 -d ' ')"

if [[ "$is_muted" == "yes" ]]; then
    echo "YES"
else
    echo "NO"
fi
