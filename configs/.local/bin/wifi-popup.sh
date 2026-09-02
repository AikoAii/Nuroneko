#!/bin/bash
set -euo pipefail

# Open connection editor window
nm-connection-editor &

# Wait for the window to spawn
sleep 0.6

# Retrieve the latest window address
addr=$(hyprctl clients -j | jq -r '.[] | select(.class=="nm-connection-editor") | .address' | tail -n1)

# If window address is found, apply geometry rules
if [ -n "$addr" ]; then
    hyprctl dispatch setfloating address:$addr
    hyprctl dispatch resizewindowpixel exact 600 500,address:$addr
    hyprctl dispatch movewindowpixel exact 1300 80,address:$addr
    hyprctl dispatch focuswindow address:$addr
fi
