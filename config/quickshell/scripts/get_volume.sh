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

pactl get-${sink_source}-volume @DEFAULT_${SINK_SOURCE}@ | head --lines=1 | sed 's/ \+//g' | cut -f2 -d '/' | sed 's/%$//'
