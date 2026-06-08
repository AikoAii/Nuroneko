#!/usr/bin/env bash
# scripts/install/services.sh — Enable required system services

enable_services() {
  info "Setting up services..."

  # --- Load init detection and backend ---
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
  require_function enable_service

  # --- Detect init system ---
  detect_init || error "Failed to detect init system"
  load_init_backend || error "Failed to load init backend"

  # --- Services to enable ---
  # These are the core services required for a functional desktop environment
  local -a services=(
    "NetworkManager"
    "bluetooth"
    "sddm"
  )

  info "Enabling services for init system: $INIT_SYSTEM"

  for service in "${services[@]}"; do
    # Try system-level service first
    if enable_service "$service" "system"; then
      ((ENABLED_SERVICES++)) || true
      ok "Enabled service: $service"
    else
      warn "Failed to enable service: $service"
    fi
  done

  ok "Service setup complete"
}
