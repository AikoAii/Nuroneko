#!/usr/bin/env bash
# scripts/install/init/dinit.sh — dinit service management backend

enable_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    if command -v dinitctl >/dev/null 2>&1 && dinitctl --user list >/dev/null 2>&1; then
      if dinitctl --user enable "$service" >/dev/null 2>&1 && dinitctl --user start "$service" >/dev/null 2>&1; then
        return 0
      fi
    else
      warn "User-level dinit not configured; enabling system-wide: $service"
    fi
  fi

  # Fall back to system-level
  if sudo dinitctl enable "$service" >/dev/null 2>&1 && sudo dinitctl start "$service" >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to enable service: $service"
  return 1
}

start_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]] && dinitctl --user list >/dev/null 2>&1; then
    if dinitctl --user start "$service" >/dev/null 2>&1; then
      return 0
    fi
  fi

  if sudo dinitctl start "$service" >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to start service: $service"
  return 1
}

restart_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]] && dinitctl --user list >/dev/null 2>&1; then
    if dinitctl --user restart "$service" >/dev/null 2>&1; then
      return 0
    fi
  fi

  if sudo dinitctl restart "$service" >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to restart service: $service"
  return 1
}

stop_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]] && dinitctl --user list >/dev/null 2>&1; then
    if dinitctl --user stop "$service" >/dev/null 2>&1; then
      return 0
    fi
  fi

  if sudo dinitctl stop "$service" >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to stop service: $service"
  return 1
}
