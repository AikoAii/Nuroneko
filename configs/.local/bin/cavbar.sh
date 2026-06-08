#!/bin/bash

# bar character (low → high)
bars=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

# cava
stdbuf -oL cava -p ~/.config/cava/config-waybar | while read -r line; do
    output=""
    
    IFS=';' read -ra values <<< "$line"

    for v in "${values[@]}"; do
        [[ -z "$v" ]] && continue

        ((v<0)) && v=0
        ((v>7)) && v=7

        output+="${bars[$v]}"
    done

    printf '{"text":"%s"}\n' "$output"
done
