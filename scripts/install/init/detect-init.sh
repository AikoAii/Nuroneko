#!/usr/bin/env bash
# scripts/install/init/detect-init.sh — Detect active init system

detect_init() {
  info "Detecting init system..."

  # --- Canonical systemd detection ---
  if [[ -d /run/systemd/system ]]; then
    export INIT_SYSTEM="systemd"
    ok "Init system: systemd"
    return 0
  fi

  # --- Check PID 1 ---
  local init_bin
  init_bin=$(readlink -f /sbin/init 2>/dev/null || echo "")

  if [[ "$init_bin" == *"systemd"* ]]; then
    export INIT_SYSTEM="systemd"
    ok "Init system: systemd"
    return 0
  elif [[ "$init_bin" == *"dinit"* ]] || command -v dinitctl >/dev/null 2>&1; then
    export INIT_SYSTEM="dinit"
    ok "Init system: dinit"
    return 0
  elif [[ "$init_bin" == *"openrc"* ]] || [[ -f /run/openrc/softlevel ]] || command -v rc-service >/dev/null 2>&1; then
    export INIT_SYSTEM="openrc"
    ok "Init system: openrc"
    return 0
  elif [[ "$init_bin" == *"runit"* ]] || command -v sv >/dev/null 2>&1; then
    export INIT_SYSTEM="runit"
    ok "Init system: runit"
    return 0
  fi

  # --- Fallback: check /proc/1/comm ---
  local comm
  comm=$(cat /proc/1/comm 2>/dev/null || echo "")

  case "$comm" in
    systemd)
      export INIT_SYSTEM="systemd"
      ok "Init system: systemd"
      return 0
      ;;
    dinit)
      export INIT_SYSTEM="dinit"
      ok "Init system: dinit"
      return 0
      ;;
    openrc*)
      export INIT_SYSTEM="openrc"
      ok "Init system: openrc"
      return 0
      ;;
    runit)
      export INIT_SYSTEM="runit"
      ok "Init system: runit"
      return 0
      ;;
    *)
      error "Unknown init system: $comm (supported: systemd, openrc, runit, dinit)"
      ;;
  esac
}
