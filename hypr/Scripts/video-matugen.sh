#!/bin/bash

VIDEO_DIR="$HOME/Pictures/wallpapers/Live"
CACHE_IMG="$HOME/.config/hypr/current_wall.jpg"

# Videoları bul ve sadece dosya adını göster
VIDEO_LIST=$(find "$VIDEO_DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \))

BASENAME_LIST=$(echo "$VIDEO_LIST" | awk -F/ '{print $NF}')

CHOSEN=$(echo "$BASENAME_LIST" | rofi -dmenu -i -p "Select Video")

[ -z "$CHOSEN" ] && exit 0

VIDEO=$(echo "$VIDEO_LIST" | grep "$CHOSEN")

pkill mpvpaper

ffmpeg -loglevel quiet -y -i "$VIDEO" -ss 00:00:02 -vframes 1 "$CACHE_IMG"

matugen image "$CACHE_IMG"

killall -SIGUSR2 waybar 2>/dev/null

mpvpaper -f -o "no-audio loop profile=fast hwdec=auto" '*' "$VIDEO"

