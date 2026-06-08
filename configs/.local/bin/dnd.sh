#!/usr/bin/env bash

status=$(swaync-client -D)

if [ "$status" = "true" ]; then
  icon="󰂛"
  class="enabled"
else
  icon="󰂚"
  class="disabled"
fi

printf '{"text":"%s","class":"%s"}\n' \
  "$icon" \
  "$class"
