#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
ROFI_CONFIG="$HOME/.config/rofi/pure-wall.rasi"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"
IMAGE_EXTENSIONS=("jpg" "jpeg" "png" "gif" "webp")

is_image() {
    local f="$1"
    for ext in "${IMAGE_EXTENSIONS[@]}"; do
        [[ "${f,,}" == *.$ext ]] && return 0
    done
    return 1
}

pick_random_wallpaper() {
    find "$WALLPAPER_DIR" -maxdepth 1 -type f | grep -Ei '\.(jpg|jpeg|png|gif|webp)$' | shuf -n 1
}

reload_service() {
    case "$1" in
        hyprpaper)
            pkill hyprpaper 2>/dev/null || true
            sleep 0.2
            hyprpaper &
            ;;
        swaync)
            pkill swaync 2>/dev/null || true
            sleep 0.2
            swaync 2>/dev/null &
            ;;
        waybar)
            pkill waybar 2>/dev/null || true
            sleep 0.2
            waybar &
            ;;
    esac
}

cd "$WALLPAPER_DIR" || exit 1

RANDOM_WALL="$(pick_random_wallpaper || true)"

SELECTED_WALL="$(
{
    [[ -n "${RANDOM_WALL:-}" ]] && \
        printf "󰒺 Random Wallpaper\0icon\x1f%s\n" "$RANDOM_WALL"

    find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        | grep -Ei '\.(jpg|jpeg|png|gif|webp)$' \
        | sort -r \
        | while read -r img; do
            printf "%s\0icon\x1f%s\n" "$(basename "$img")" "$img"
          done
} | rofi -dmenu -i -show-icons -config "$ROFI_CONFIG"
)"

[[ -z "$SELECTED_WALL" ]] && exit 0

if [[ "$SELECTED_WALL" == *Random* ]]; then
    SELECTED_PATH="$RANDOM_WALL"
else
    SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"
fi

matugen image "$SELECTED_PATH" --source-color-index 0

mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

reload_service hyprpaper
reload_service swaync || true
reload_service waybar
