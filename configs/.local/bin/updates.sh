#!/bin/bash

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/updates"
CACHE_FILE="$CACHE_DIR/count"
CACHE_DURATION=300

mkdir -p "$CACHE_DIR"

# CACHE
if [ -f "$CACHE_FILE" ]; then
    now=$(date +%s)
    last=$(stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE")
    age=$((now - last))

    if [ "$age" -lt "$CACHE_DURATION" ]; then
        updates=$(cat "$CACHE_FILE")
    fi
fi

# HITUNG
if [ -z "$updates" ]; then
    ofc=$(checkupdates 2>/dev/null | wc -l)

    if command -v yay &>/dev/null; then
        aur=$(yay -Qum 2>/dev/null | wc -l)
    elif command -v paru &>/dev/null; then
        aur=$(paru -Qum 2>/dev/null | wc -l)
    else
        aur=0
    fi

    updates=$((ofc + aur))
    echo "$updates" > "$CACHE_FILE"
fi

# --- ANIMATION FRAME ---
frame=$(( $(date +%s) % 2 ))

if [ "$frame" -eq 0 ]; then
    icon="󰮯"
else
    icon="󰊠"
fi

# CLASS
if [ "$updates" -gt 0 ]; then
    class="warning"
else
    class="normal"
fi

# OUTPUT
printf '{"text":"%s %d","class":"%s"}\n' "$icon" "$updates" "$class"
