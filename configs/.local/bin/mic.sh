#!/bin/bash

info=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
volume=$(echo "$info" | awk '{print int($2 * 100)}')
if echo "$info" | grep -q "MUTED" || [ "$volume" -eq 0 ]; then
    muted=true
else
    muted=false
fi

# ICON
if [ "$muted" = true ]; then
    icon="󰍭"
else
    icon="󰍬"
fi

# CLASS
if [ "$muted" = true ]; then
    class="muted"
elif [ "$volume" -ge 80 ]; then
    class="warning"
else
    class="normal"
fi

# OUTPUT
printf '{"text":"%s %d%%","class":"%s","tooltip":"Mic: %d%%"}\n' \
"$icon" "$volume" "$class" "$volume"
