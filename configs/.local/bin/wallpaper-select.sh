#!/usr/bin/env bash

WALL_DIR="$HOME/.local/share/wallpapers"

SELECTED=$(
    find "$WALL_DIR" \
        -maxdepth 1 \
        -type f \
        ! -name "current" |
    while read -r img; do
        printf "%s\0icon\x1f%s\n" "$img" "$img"
    done |
    rofi \
        -dmenu \
        -theme ~/.config/rofi/themes/selecting.rasi
)

[ -z "$SELECTED" ] && exit

~/.config/AikoAi/wallpaper-set "$SELECTED"
