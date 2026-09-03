#!/usr/bin/env bash
set -euo pipefail

# Network traffic monitor for Waybar
# Displays current download/upload speed.

INTERVAL=1

get_interface() {
  ip route show default 2>/dev/null |
    awk '/default/ {print $5; exit}'
}

get_bytes() {
  local interface="$1"

  if [[ ! -d "/sys/class/net/$interface" ]]; then
    echo "0 0"
    return
  fi

  local rx tx

  rx=$(<"/sys/class/net/$interface/statistics/rx_bytes")
  tx=$(<"/sys/class/net/$interface/statistics/tx_bytes")

  echo "$rx $tx"
}

format_speed() {
  local bytes="$1"

  if ((bytes >= 1073741824)); then
    awk "BEGIN {printf \"%.1fG\", $bytes / 1073741824}"
  elif ((bytes >= 1048576)); then
    awk "BEGIN {printf \"%.1fM\", $bytes / 1048576}"
  elif ((bytes >= 1024)); then
    awk "BEGIN {printf \"%.0fK\", $bytes / 1024}"
  else
    printf "%dB" "$bytes"
  fi
}

main() {
  local interface
  interface=$(get_interface)

  if [[ -z "$interface" ]]; then
    printf '{"text":"󰖪","tooltip":"Network: Offline","class":"offline"}\n'
    exit 0
  fi

  local rx1 tx1 rx2 tx2
  read -r rx1 tx1 <<<"$(get_bytes "$interface")"

  sleep "$INTERVAL"

  read -r rx2 tx2 <<<"$(get_bytes "$interface")"

  local rx_rate tx_rate
  rx_rate=$(((rx2 - rx1) / INTERVAL))
  tx_rate=$(((tx2 - tx1) / INTERVAL))

  local download upload
  download=$(format_speed "$rx_rate")
  upload=$(format_speed "$tx_rate")

  printf '{"text":"↓ %s ↑ %s","tooltip":"Interface: %s\\n↓ Download: %s/s\\n↑ Upload: %s/s","class":"connected"}\n' \
    "$download" \
    "$upload" \
    "$interface" \
    "$download" \
    "$upload"
}

main
