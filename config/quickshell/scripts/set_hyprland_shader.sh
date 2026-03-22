#!/usr/bin/env bash

shader_path="$1"

scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
shaders_dir="$(dirname "$scripts_dir")/shaders"

expand_path () {
    local path="$1"

    local restore="$(pwd)"

    if [[ "$path" == "/"* ]]; then
        echo "$path"
        return
    fi

    if [[ "$(basename "$path")" == "$path" ]]; then
        path="./${path}"
    fi

    if [[ -d "$path" ]]; then
        cd "$path"
        pwd
        cd "$restore"
    else
        local name="$(basename "${path}")"

        local name_parent="$(echo "${path}" | sed "s/\/${name}$//g")"

        cd "$name_parent"
        echo "$(pwd)/${name}"
        cd "$restore"
    fi
}

set_shader () {
    local shader="$1"

    local path="$(expand_path "$shader")"

    local shader_arg=""
    if [[ "$shader" == "" ]]; then
        shader_arg="[[EMPTY]]"
    else
        if [[ ${SET_SHADER_BY_NAME} == 1 ]]; then
            shader_arg="${shaders_dir}/${shader}.glsl"
        else
            shader_arg="$path"
        fi
    fi

    hyprctl keyword decoration:screen_shader "$shader_arg"
}

if [[ "$shader_path" == "NULL" ]]; then
    set_shader ""
else
    set_shader "$shader_path"
fi
