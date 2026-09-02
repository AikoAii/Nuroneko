#!/usr/bin/env bash
# scripts/install/init/openrc.sh — OpenRC service management backend

service_exists() {
  local service="$1"
  [[ -f "/etc/init.d/$service" ]] || command -v rc-service >/dev/null 2>&1 && rc-service -l 2>/dev/null | grep -qw "$service"
}

enable_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    warn "OpenRC does not support user services; enabling system-wide: $service"
  fi

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would enable OpenRC service (sudo): %s\n" "$CYAN" "$NC" "$service"
    return 0
  fi

  info "Executing privileged command (sudo) to enable OpenRC service: $service"
  if sudo rc-update add "$service" default >/dev/null 2>&1; then
    sudo rc-service "$service" start >/dev/null 2>&1 || true
    return 0
  fi

  warn "Failed to enable service: $service"
  return 1
}

disable_service() {
  local service="$1"

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would disable OpenRC service (sudo): %s\n" "$CYAN" "$NC" "$service"
    return 0
  fi

  sudo rc-service "$service" stop >/dev/null 2>&1 || true
  sudo rc-update del "$service" default >/dev/null 2>&1
}

start_service() {
  local service="$1"

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would start OpenRC service (sudo): %s\n" "$CYAN" "$NC" "$service"
    return 0
  fi

  sudo rc-service "$service" start >/dev/null 2>&1
}

restart_service() {
  local service="$1"

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would restart OpenRC service (sudo): %s\n" "$CYAN" "$NC" "$service"
    return 0
  fi

  sudo rc-service "$service" restart >/dev/null 2>&1
}

stop_service() {
  local service="$1"

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would stop OpenRC service (sudo): %s\n" "$CYAN" "$NC" "$service"
    return 0
  fi

  sudo rc-service "$service" stop >/dev/null 2>&1
}

service_status() {
  local service="$1"
  rc-service "$service" status >/dev/null 2>&1
}
