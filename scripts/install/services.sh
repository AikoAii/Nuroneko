#!/usr/bin/env bash
# scripts/install/services.sh — Enable required system services

enable_services() {
  info "Setting up services..."

  local init_detect="${DOTFILES_DIR}/scripts/install/init/detect-init.sh"
  local init_common="${DOTFILES_DIR}/scripts/install/init/common.sh"

  [[ -f "$init_detect" ]] || error "Missing init detection module: $init_detect"
  [[ -f "$init_common" ]] || error "Missing init common module: $init_common"

  # shellcheck source=/dev/null
  source "$init_detect" || error "Failed to source init detection"
  # shellcheck source=/dev/null
  source "$init_common" || error "Failed to source init common"

  require_function detect_init
  require_function load_init_backend

  detect_init || error "Failed to detect init system"
  load_init_backend || error "Failed to load init backend"

  # Logical services list
  local -a services=(
    "NetworkManager"
    "bluetooth"
    "sddm"
  )

  info "Verifying and enabling services for init system: $INIT_SYSTEM"

  for service in "${services[@]}"; do
    if declare -F service_exists >/dev/null 2>&1 && ! service_exists "$service" "system"; then
      warn "Service '$service' not found on system for $INIT_SYSTEM (skipping service enablement)"
      continue
    fi

    if enable_service "$service" "system"; then
      ((ENABLED_SERVICES++)) || true
      ok "Enabled service: $service"
    else
      warn "Optional service '$service' could not be enabled (continuing)"
    fi
  done

  ok "Service setup complete"
}
