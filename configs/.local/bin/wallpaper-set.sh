#!/usr/bin/env bash

WALL_DIR="$HOME/.local/share/wallpapers"
CURRENT="$WALL_DIR/current"

ROFI_CACHE="$HOME/.cache/rofi"
ROFI_WALL="$ROFI_CACHE/wallpaper.png"

IMG="$1"

[[ ! -f "$IMG" ]] && exit 1

mkdir -p "$ROFI_CACHE"

# Monitor size
read -r WIDTH HEIGHT < <(
  hyprctl monitors -j |
    jq -r '.[0] | "\(.width) \(.height)"'
)

# Random transition
TRANSITION=$(shuf -e grow outer wipe -n1)

case "$TRANSITION" in

grow | outer)

  X=$(shuf -i 0-"$WIDTH" -n1)
  Y=$(shuf -i 0-"$HEIGHT" -n1)

  awww img "$IMG" \
    --transition-type "$TRANSITION" \
    --transition-pos "$X,$Y" \
    --transition-duration 0.75 \
    --transition-fps 120
  ;;

wipe)

  ANGLE=$(shuf -e 45 135 225 315 -n1)

  awww img "$IMG" \
    --transition-type wipe \
    --transition-angle "$ANGLE" \
    --transition-duration 0.75 \
    --transition-fps 120
  ;;
esac

# Save current wallpaper
ln -sfn "$(realpath "$IMG")" "$CURRENT"


# Generate rofi preview
magick "$IMG" \
  -resize 500x500^ \
  -gravity center \
  -extent 500x500 \
  "$ROFI_WALL"
