#!/usr/bin/env bash
# scripts/install/init/runit.sh — runit service management backend

enable_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    warn "runit does not support user services; enabling system-wide: $service"
  fi

  if [[ ! -d "/etc/sv/$service" ]]; then
    warn "Service directory not found: /etc/sv/$service"
    return 1
  fi

  if sudo ln -sf "/etc/sv/$service" "/var/service/" >/dev/null 2>&1; then
    if sudo sv start "$service" >/dev/null 2>&1; then
      return 0
    fi
  fi

  warn "Failed to enable service: $service"
  return 1
}

start_service() {
  local service="$1"
  local level="${2:-system}"

  if sudo sv start "$service" >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to start service: $service"
  return 1
}

restart_service() {
  local service="$1"
  local level="${2:-system}"

  if sudo sv restart "$service" >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to restart service: $service"
  return 1
}

stop_service() {
  local service="$1"
  local level="${2:-system}"

  if sudo sv stop "$service" >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to stop service: $service"
  return 1
}
