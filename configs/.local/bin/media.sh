#!/bin/bash

# Configuration
MAX_LEN=20
SPEED=0.3

scroll_text() {
  local text="$1"
  local len=${#text}

  text="$text   "
  local padded_len=${#text}

  if [ "$len" -le "$MAX_LEN" ]; then
    printf '{"text":"%s %s","class":"normal","tooltip":"%s"}\n' "$icon" "$1" "$full_metadata"
    sleep 1
    return
  fi

  for ((i = 0; i < padded_len; i++)); do
    local slice="${text:$i:$MAX_LEN}"

    if [ ${#slice} -lt "$MAX_LEN" ]; then
      local remainder=$((MAX_LEN - ${#slice}))
      slice="${slice}${text:0:$remainder}"
    fi

    printf '{"text":"%s %s","class":"normal","tooltip":"%s"}\n' "$icon" "$slice" "$full_metadata"
    sleep "$SPEED"
  done
}

while true; do
  player=$(playerctl -l 2>/dev/null | head -n1)

  if [ -z "$player" ]; then
    printf '{"text":"󰝛 No Media","class":"muted","tooltip":"No media playing"}\n'
    sleep 2
    continue
  fi

  status=$(playerctl status 2>/dev/null)
  artist=$(playerctl metadata artist 2>/dev/null)
  title=$(playerctl metadata title 2>/dev/null)

  if [ -n "$artist" ] && [ -n "$title" ]; then
    display_text="$artist - $title"
  elif [ -n "$title" ]; then
    display_text="$title"
  else
    display_text="Unknown Source"
  fi

  full_metadata="Artist: ${artist:-Unknown}\nTitle: ${title:-Unknown}"

  if [ "$status" = "Playing" ]; then
    icon="󰏤"
    scroll_text "$display_text"
  else
    icon="󰐊"
    printf '{"text":"%s %s","class":"paused","tooltip":"%s (Paused)"}\n' "$icon" "${display_text:0:$MAX_LEN}" "$full_metadata"
    sleep 1
  fi
done
