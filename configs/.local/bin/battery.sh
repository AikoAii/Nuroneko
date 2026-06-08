#!/usr/bin/env bash

# detect battery

for bat in /sys/class/power_supply/BAT*; do
    [ -d "$bat" ] && break
done

# fallback

if [ ! -d "$bat" ]; then
    printf '{"text":"󱟩","class":"unknown","tooltip":"Battery not found"}\n'
    exit 0
fi

# battery data

capacity=$(cat "$bat/capacity" 2>/dev/null || echo 0)

status=$(cat "$bat/status" 2>/dev/null || echo "Unknown")

power_now=$(cat "$bat/power_now" 2>/dev/null || echo 0)

energy_now=$(cat "$bat/energy_now" 2>/dev/null || echo 0)

energy_full=$(cat "$bat/energy_full" 2>/dev/null || echo 0)

# health %

if [ "$energy_full" -gt 0 ]; then
    health=$(( energy_full * 100 / energy_full ))
else
    health=100
fi

# icon

if [ "$status" = "Charging" ]; then
    icon="󰂄"

elif [ "$capacity" -ge 95 ]; then
    icon="󰁹"

elif [ "$capacity" -ge 80 ]; then
    icon="󰂂"

elif [ "$capacity" -ge 60 ]; then
    icon="󰂀"

elif [ "$capacity" -ge 40 ]; then
    icon="󰁾"

elif [ "$capacity" -ge 20 ]; then
    icon="󰁻"

else
    icon="󰂎"
fi

# class

if [ "$status" = "Charging" ]; then
    class="charging"

elif [ "$capacity" -le 10 ]; then
    class="critical"

elif [ "$capacity" -le 25 ]; then
    class="warning"

else
    class="normal"
fi

# tooltip

tooltip="Battery: ${capacity}% | Status: ${status}"

printf '{"text":"%s %d%%","class":"%s","tooltip":"%s"}\n' \
"$icon" \
"$capacity" \
"$class" \
"$tooltip"
