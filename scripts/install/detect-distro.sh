#!/usr/bin/env bash
# scripts/install/detect-distro.sh — Detect Linux distribution

detect_distro() {
  info "Detecting Linux distribution..."

  if [[ ! -f /etc/os-release ]]; then
    error "Cannot detect OS: /etc/os-release not found"
  fi

  # shellcheck source=/dev/null
  source /etc/os-release

  local detected_id="${ID:-unknown}"
  local detected_like="${ID_LIKE:-}"
  local detected_name="${PRETTY_NAME:-Linux}"

  export DISTRO_NAME="$detected_name"

  case "$detected_id" in
    arch)
      export DISTRO="arch"
      export DISTRO_FAMILY="arch"
      ok "Detected distribution: $detected_name (Arch Linux)"
      ;;
    artix)
      export DISTRO="artix"
      export DISTRO_FAMILY="arch"
      ok "Detected distribution: $detected_name (Artix Linux)"
      ;;
    *)
      if [[ "$detected_like" == *"arch"* ]]; then
        export DISTRO="$detected_id"
        export DISTRO_FAMILY="arch"
        ok "Detected distribution: $detected_name (Arch-based)"
      else
        error "Unsupported distribution: $detected_name (Currently only Arch Linux and Artix Linux are supported)"
      fi
      ;;
  esac
}
