#!/usr/bin/env bash
# scripts/install/init/systemd.sh — systemd service management backend

service_exists() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    systemctl --user list-unit-files "${service}.service" >/dev/null 2>&1 || \
    systemctl --user list-unit-files "${service}" >/dev/null 2>&1
  else
    systemctl list-unit-files "${service}.service" >/dev/null 2>&1 || \
    systemctl list-unit-files "${service}" >/dev/null 2>&1
  fi
}

enable_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would enable user systemd service: %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    systemctl --user enable --now "$service" >/dev/null 2>&1 && return 0
    warn "Failed to enable user service: $service"
    return 1
  else
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would enable system systemd service (sudo): %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    info "Executing privileged command (sudo) to enable systemd service: $service"
    sudo systemctl enable --now "$service" >/dev/null 2>&1 && return 0
    warn "Failed to enable system service: $service"
    return 1
  fi
}

disable_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would disable user systemd service: %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    systemctl --user disable --now "$service" >/dev/null 2>&1 && return 0
    return 1
  else
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would disable system systemd service (sudo): %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    sudo systemctl disable --now "$service" >/dev/null 2>&1 && return 0
    return 1
  fi
}

start_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would start user systemd service: %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    systemctl --user start "$service" >/dev/null 2>&1 && return 0
    return 1
  else
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would start system systemd service (sudo): %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    sudo systemctl start "$service" >/dev/null 2>&1 && return 0
    return 1
  fi
}

restart_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would restart user systemd service: %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    systemctl --user restart "$service" >/dev/null 2>&1 && return 0
    return 1
  else
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would restart system systemd service (sudo): %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    sudo systemctl restart "$service" >/dev/null 2>&1 && return 0
    return 1
  fi
}

stop_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would stop user systemd service: %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    systemctl --user stop "$service" >/dev/null 2>&1 && return 0
    return 1
  else
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would stop system systemd service (sudo): %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    sudo systemctl stop "$service" >/dev/null 2>&1 && return 0
    return 1
  fi
}

service_status() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]]; then
    systemctl --user is-active "$service" >/dev/null 2>&1
  else
    systemctl is-active "$service" >/dev/null 2>&1
  fi
}
