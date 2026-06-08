#!/bin/bash

# buka window
nm-connection-editor &

# tunggu window muncul
sleep 0.6

# ambil address window terbaru
addr=$(hyprctl clients -j | jq -r '.[] | select(.class=="nm-connection-editor") | .address' | tail -n1)

# kalau ketemu
if [ -n "$addr" ]; then
    hyprctl dispatch setfloating address:$addr
    hyprctl dispatch resizewindowpixel exact 600 500,address:$addr
    hyprctl dispatch movewindowpixel exact 1300 80,address:$addr
    hyprctl dispatch focuswindow address:$addr
fi
