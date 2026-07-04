#!/usr/bin/env bash

set -euo pipefail

THEME="$HOME/.config/rofi/themes/clipboard.rasi"

case "${1:-list}" in
    list)
        cliphist list \
            | rofi -dmenu -i \
                -theme "$THEME" \
                -p "󰅍 Clipboard :" \
            | cliphist decode \
            | wl-copy
        ;;

    clear)
        cliphist wipe
        notify-send "󰅍 Clipboard" "History cleared"
        ;;
esac
