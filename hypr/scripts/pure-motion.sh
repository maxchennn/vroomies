#!/usr/bin/env bash

ANIM_DIR="$HOME/.config/hypr/motions"
TARGET_CONF="$HOME/.config/hypr/motions.conf"
ROFI_THEME="$HOME/.config/rofi/pure-motion.rasi"

main() {
    # Sadece listeyi çek ve ikon ekle
   choice=$(ls "$ANIM_DIR" | sed 's/\.conf//' | sed 's/^/󰚗  /' | rofi -dmenu -i -p "" -theme "$ROFI_THEME")

    if [[ -n "$choice" ]]; then
        clean_choice=$(echo "$choice" | sed 's/󰚗  //')
        cp "$ANIM_DIR/$clean_choice.conf" "$TARGET_CONF"
        
        notify-send -e -h string:x-canonical-private-synchronous:anim_notif \
            "Hyprland" "Animations switched to '$clean_choice' successfully."
    fi
}

main
