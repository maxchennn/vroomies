#!/usr/bin/env bash

THEMES_DIR="$HOME/.config/waybar/themes"
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
ROFI_THEME="$HOME/.config/rofi/pure-way.rasi"

main() {
    # -p parametresini ekledik, dmenu yazısını ezdik knk
    choice=$(ls "$THEMES_DIR" | rofi -dmenu -i -theme "$ROFI_THEME")

    if [[ -n "$choice" ]]; then
        cp "$THEMES_DIR/$choice/config.jsonc" "$WAYBAR_CONFIG"
        cp "$THEMES_DIR/$choice/style.css" "$WAYBAR_STYLE"

        pkill waybar
        # Fedora'da bazen waybar geç kapanır, beklemek iyidir
        while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done
        waybar &

        notify-send -e -u low -i "waybar" \
            -h string:x-canonical-private-synchronous:waybar_notif \
            "󱑒  System Flow Optimized" \
            "Interface synchronized with <b>$choice</b> style."
    fi
}

main
