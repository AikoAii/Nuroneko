#!/usr/bin/env bash
# scripts/install/init/dinit.sh — dinit service management backend

service_exists() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]] && command -v dinitctl >/dev/null 2>&1; then
    dinitctl --user list 2>/dev/null | grep -qw "$service" && return 0
  fi

  [[ -f "/etc/dinit.d/$service" ]] || {
    command -v dinitctl >/dev/null 2>&1 && dinitctl list 2>/dev/null | grep -qw "$service"
  }
}

enable_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]] && command -v dinitctl >/dev/null 2>&1; then
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would enable user dinit service: %s\n" "$CYAN" "$NC" "$service"
      return 0
    fi
    if dinitctl --user enable "$service" >/dev/null 2>&1 && dinitctl --user start "$service" >/dev/null 2>&1; then
      return 0
    fi
  fi

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would enable system dinit service (sudo): %s\n" "$CYAN" "$NC" "$service"
    return 0
  fi

  info "Executing privileged command (sudo) to enable dinit service: $service"
  if sudo dinitctl enable "$service" >/dev/null 2>&1 && sudo dinitctl start "$service" >/dev/null 2>&1; then
    return 0
  fi

  warn "Failed to enable dinit service: $service"
  return 1
}

disable_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would disable dinit service: %s\n" "$CYAN" "$NC" "$service"
    return 0
  fi

  if [[ "$level" == "user" ]] && command -v dinitctl >/dev/null 2>&1; then
    dinitctl --user disable "$service" >/dev/null 2>&1 || true
    dinitctl --user stop "$service" >/dev/null 2>&1 || true
    return 0
  fi

  sudo dinitctl disable "$service" >/dev/null 2>&1 || true
  sudo dinitctl stop "$service" >/dev/null 2>&1 || true
}

start_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would start dinit service: %s\n" "$CYAN" "$NC" "$service"
    return 0
  fi

  if [[ "$level" == "user" ]] && command -v dinitctl >/dev/null 2>&1; then
    dinitctl --user start "$service" >/dev/null 2>&1 && return 0
  fi

  sudo dinitctl start "$service" >/dev/null 2>&1
}

restart_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would restart dinit service: %s\n" "$CYAN" "$NC" "$service"
    return 0
  fi

  if [[ "$level" == "user" ]] && command -v dinitctl >/dev/null 2>&1; then
    dinitctl --user restart "$service" >/dev/null 2>&1 && return 0
  fi

  sudo dinitctl restart "$service" >/dev/null 2>&1
}

stop_service() {
  local service="$1"
  local level="${2:-system}"

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would stop dinit service: %s\n" "$CYAN" "$NC" "$service"
    return 0
  fi

  if [[ "$level" == "user" ]] && command -v dinitctl >/dev/null 2>&1; then
    dinitctl --user stop "$service" >/dev/null 2>&1 && return 0
  fi

  sudo dinitctl stop "$service" >/dev/null 2>&1
}

service_status() {
  local service="$1"
  local level="${2:-system}"

  if [[ "$level" == "user" ]] && command -v dinitctl >/dev/null 2>&1; then
    dinitctl --user is-active "$service" >/dev/null 2>&1 && return 0
  fi

  sudo dinitctl is-active "$service" >/dev/null 2>&1
}
