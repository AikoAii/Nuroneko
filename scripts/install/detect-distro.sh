#!/usr/bin/env bash
# scripts/install/detect-distro.sh — Detect Linux distribution

detect_distro() {
  info "Detecting Linux distribution..."

  # --- Read /etc/os-release ---
  if [[ ! -f /etc/os-release ]]; then
    error "Cannot detect OS: /etc/os-release not found"
  fi

  # shellcheck source=/dev/null
  source /etc/os-release

  local detected_id="${ID:-unknown}"
  local detected_name="${PRETTY_NAME:-Linux}"

  # --- Validate supported distro ---
  case "$detected_id" in
    arch)
      export DISTRO="arch"
      ok "Detected: $detected_name (Arch Linux)"
      ;;
    artix)
      export DISTRO="artix"
      ok "Detected: $detected_name (Artix Linux)"
      ;;
    *)
      error "Unsupported distribution: $detected_name (Only Arch and Artix are supported)"
      ;;
  esac
}
