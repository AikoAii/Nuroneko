#!/bin/bash

vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

volume=$(echo "$vol_info" | awk '{printf "%d", $2*100}')

if echo "$vol_info" | grep -q "MUTED" || [ "$volume" -eq 0 ]; then
    muted=true
else
    muted=false
fi

# --- ICON ---
if [ "$muted" = true ]; then
    icon="󰝟"
elif [ "$volume" -ge 70 ]; then
    icon="󰕾"
elif [ "$volume" -ge 30 ]; then
    icon="󰖀"
else
    icon="󰕿"
fi

# --- CLASS ---
if [ "$muted" = true ]; then
    class="muted"
elif [ "$volume" -ge 80 ]; then
    class="warning"
else
    class=""
fi

# --- OUTPUT ---
printf '{"text":"%s %d%%","class":"%s"}\n' "$icon" "$volume" "$class"
