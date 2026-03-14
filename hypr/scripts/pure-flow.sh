#!/usr/bin/env bash

KEY_FILE="$HOME/.config/hypr/keybinds.txt"
ROFI_THEME="$HOME/.config/rofi/pure-flow.rasi"

# Dosya kontrolü (tedbir amaçlı)
if [ ! -f "$KEY_FILE" ]; then
    notify-send "Error" "Keybinds file not found!"
    exit 1
fi

# Rofi'yi çalıştır
cat "$KEY_FILE" | rofi -dmenu -i -p "󰌌  Search the Key" -theme "$ROFI_THEME"
