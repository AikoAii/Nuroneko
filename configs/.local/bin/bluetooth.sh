#!/bin/bash

# cek power
power=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

# cek device connected
connected=$(bluetoothctl info 2>/dev/null | grep "Connected: yes")

if [ "$power" = "no" ]; then
    icon="󰂲"
    class="off"
elif [ -n "$connected" ]; then
    name=$(bluetoothctl info | grep "Name" | cut -d ' ' -f2-)
    icon="󰂱"
    class="connected"
else
    icon="󰂯"
    class="on"
fi

# output
printf '{"text":"%s","class":"%s","tooltip":"Bluetooth"}\n' "$icon" "$class"
