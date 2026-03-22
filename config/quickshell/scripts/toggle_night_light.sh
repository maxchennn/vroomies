#!/usr/bin/env bash

scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

is_on="$("${scripts_dir}/is_night_light.sh")"

if [[ "$is_on" == "YES" ]]; then
    "${scripts_dir}/set_hyprland_shader.sh" "NULL"
else
    SET_SHADER_BY_NAME=1 "${scripts_dir}/set_hyprland_shader.sh" "night_light"
fi
