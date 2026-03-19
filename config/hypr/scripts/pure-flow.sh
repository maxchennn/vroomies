#!/usr/bin/env bash

KEY_FILE="$HOME/.config/hypr/keybinds.txt"
ROFI_THEME="$HOME/.config/rofi/pure-flow.rasi"

[[ ! -f "$KEY_FILE" ]] && notify-send "Error" "Keybinds file not found!" && exit 1

cat "$KEY_FILE" | rofi -dmenu -i -p "󰌌 Search Key" -theme "$ROFI_THEME"
