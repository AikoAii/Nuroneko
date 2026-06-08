#!/usr/bin/env bash

WALL_DIR="$HOME/.local/share/wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-random"

QUEUE="$CACHE_DIR/queue"

mkdir -p "$CACHE_DIR"

if [[ ! -s "$QUEUE" ]]; then
    find "$WALL_DIR" \
        -maxdepth 1 \
        -type f \
        ! -name "current" \
        | shuf > "$QUEUE"
fi

IMG=$(head -n 1 "$QUEUE")


tail -n +2 "$QUEUE" > "$QUEUE.tmp"
mv "$QUEUE.tmp" "$QUEUE"

~/.config/AikoAi/wallpaper-set "$IMG"
