#!/usr/bin/env bash
# scripts/install/init/openrc.sh — OpenRC service management backend

enable_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    warn "OpenRC does not support user services; enabling system-wide: $service"
  fi

  if sudo rc-update add "$service" default >/dev/null 2>&1; then
    if sudo rc-service "$service" start >/dev/null 2>&1; then
      return 0
    fi
  fi

  warn "Failed to enable service: $service"
  return 1
}

start_service() {
  local service="$1"
  local level="${2:-system}"

  if sudo rc-service "$service" start >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to start service: $service"
  return 1
}

restart_service() {
  local service="$1"
  local level="${2:-system}"

  if sudo rc-service "$service" restart >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to restart service: $service"
  return 1
}

stop_service() {
  local service="$1"
  local level="${2:-system}"

  if sudo rc-service "$service" stop >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to stop service: $service"
  return 1
}
