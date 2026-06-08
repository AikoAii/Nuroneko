#!/bin/bash

DIR="$HOME/Pictures/Screenshots"
FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

mkdir -p "$DIR"

notify() {
    notify-send -i camera-photo "Screenshot" "$1"
}

case "$1" in

full)
    grim "$FILE" &&
    wl-copy < "$FILE" &&
    notify "Fullscreen copied"
    ;;

select)
    grim -g "$(slurp)" "$FILE" &&
    wl-copy < "$FILE" &&
    notify "Region copied"
    ;;

smart)
    flameshot gui --raw | wl-copy &&
    notify "Smart screenshot copied"
    ;;

*)
    notify "Modes: full | select | smart"
    ;;
esac
