#!/bin/bash

# ambil device
device=$(ls /sys/class/backlight/ | head -n 1)

# fallback kalau tidak ada
[ -z "$device" ] && exit 1

# ambil brightness
current=$(cat /sys/class/backlight/$device/brightness)
max=$(cat /sys/class/backlight/$device/max_brightness)

brightness=$((current * 100 / max))

# --- ICON DINAMIS ---
case $brightness in
    9[0-9]|100) icon="" ;;
    8[0-9]) icon="" ;;
    7[0-9]) icon="" ;;
    6[0-9]) icon="" ;;
    5[0-9]) icon="" ;;
    4[0-9]) icon="" ;;
    3[0-9]) icon="" ;;
    2[0-9]) icon="" ;;
    1[0-9]) icon="" ;;
    *) icon="" ;;
esac

# --- CLASS ---
if [ "$brightness" -le 20 ]; then
    class="warning"
else
    class="normal"
fi

# --- OUTPUT JSON ---
printf '{"text":"%s %d%%","class":"%s","tooltip":"Brightness: %d%%"}\n' \
"$icon" "$brightness" "$class" "$brightness"
