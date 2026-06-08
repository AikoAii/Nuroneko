#!/bin/bash

iface=$(ip route | grep default | awk '{print $5}' | head -n1)

# --- OFFLINE ---
if [ -z "$iface" ]; then
    printf '{"text":"󰤭 Offline","class":"offline"}\n'
    exit
fi

# --- WIFI ---
if iw dev "$iface" info >/dev/null 2>&1; then
    ssid=$(iw dev "$iface" link | grep SSID | cut -d ' ' -f2-)
    signal=$(iw dev "$iface" link | grep signal | awk '{print $2}')

    strength=$(( (signal + 100) * 2 ))

    # ICON
    if [ "$strength" -ge 80 ]; then
        icon="󰤨"
    elif [ "$strength" -ge 60 ]; then
        icon="󰤥"
    elif [ "$strength" -ge 40 ]; then
        icon="󰤢"
    elif [ "$strength" -ge 20 ]; then
        icon="󰤟"
    else
        icon="󰤯"
    fi

    printf '{"text":"%s %s","class":"connected","tooltip":"WiFi: %s (%d%%)"}\n' \
    "$icon" "$ssid" "$ssid" "$strength"

else
    # Ethernet
    printf '{"text":"󰈀 Ethernet","class":"connected"}\n'
fi
