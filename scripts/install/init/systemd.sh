#!/usr/bin/env bash
# scripts/install/init/systemd.sh — systemd service management backend

enable_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    systemctl --user enable --now "$service" >/dev/null 2>&1 && return 0
    warn "Failed to enable user service: $service"
    return 1
  else
    sudo systemctl enable --now "$service" >/dev/null 2>&1 && return 0
    warn "Failed to enable system service: $service"
    return 1
  fi
}

start_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    systemctl --user start "$service" >/dev/null 2>&1 && return 0
    warn "Failed to start user service: $service"
    return 1
  else
    sudo systemctl start "$service" >/dev/null 2>&1 && return 0
    warn "Failed to start system service: $service"
    return 1
  fi
}

restart_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    systemctl --user restart "$service" >/dev/null 2>&1 && return 0
    warn "Failed to restart user service: $service"
    return 1
  else
    sudo systemctl restart "$service" >/dev/null 2>&1 && return 0
    warn "Failed to restart system service: $service"
    return 1
  fi
}

stop_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    systemctl --user stop "$service" >/dev/null 2>&1 && return 0
    warn "Failed to stop user service: $service"
    return 1
  else
    sudo systemctl stop "$service" >/dev/null 2>&1 && return 0
    warn "Failed to stop system service: $service"
    return 1
  fi
}
