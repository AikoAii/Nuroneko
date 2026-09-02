#!/usr/bin/env bash
# scripts/install/doctor.sh — Independent system & Nuroneko diagnostics tool

run_doctor() {
  echo ""
  echo "=========================================="
  echo "  Nuroneko System Diagnostics (Doctor)"
  echo "=========================================="
  echo ""

  local doc_warnings=0
  local doc_errors=0

  # --- 1. System Environment ---
  info "1. System Environment"
  local os_name="Linux"
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    source /etc/os-release
    os_name="${PRETTY_NAME:-Linux}"
  fi
  printf "   OS Distribution : %s\n" "$os_name"

  # Init System Detection
  local detected_init="unknown"
  if [[ -d /run/systemd/system ]] || [[ "$(readlink -f /sbin/init 2>/dev/null)" == *"systemd"* ]]; then
    detected_init="systemd"
  elif command -v dinitctl >/dev/null 2>&1 || [[ "$(readlink -f /sbin/init 2>/dev/null)" == *"dinit"* ]]; then
    detected_init="dinit"
  elif command -v rc-service >/dev/null 2>&1 || [[ -f /run/openrc/softlevel ]]; then
    detected_init="openrc"
  fi
  printf "   Init System     : %s\n" "$detected_init"

  # Package Manager
  local pkg_mgr="unknown"
  if command -v pacman >/dev/null 2>&1; then
    pkg_mgr="pacman"
  fi
  printf "   Package Manager : %s\n" "$pkg_mgr"
  printf "   Shell           : %s\n" "${SHELL:-/bin/bash}"
  echo ""

  # --- 2. Required Commands ---
  info "2. Required Commands"
  local required_cmds=(bash git grep sed find ln mkdir chmod mv basename date readlink pacman)
  for cmd in "${required_cmds[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      ok "Command available: $cmd"
    else
      fail "Missing required command: $cmd"
      ((doc_errors++)) || true
    fi
  done
  echo ""

  # --- 3. Optional Dependencies ---
  info "3. Optional Tools & Helpers"
  if command -v yay >/dev/null 2>&1; then
    ok "AUR helper: yay found"
  elif command -v paru >/dev/null 2>&1; then
    ok "AUR helper: paru found"
  else
    warning "No AUR helper (yay or paru) found"
    ((doc_warnings++)) || true
  fi

  if command -v whiptail >/dev/null 2>&1; then
    ok "TUI menu engine: whiptail found"
  elif command -v dialog >/dev/null 2>&1; then
    ok "TUI menu engine: dialog found"
  else
    info "TUI engine: None (using clean Bash CLI interface)"
  fi
  echo ""

  # --- 4. Configuration & File Integrity ---
  info "4. Configuration & Deployment Status"
  local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  local local_bin="$HOME/.local/bin"

  if [[ -d "$config_home/hypr" ]]; then
    ok "Hyprland config found: $config_home/hypr"
  else
    warn "Hyprland config missing: $config_home/hypr"
    ((doc_warnings++)) || true
  fi

  if [[ -d "$local_bin" ]]; then
    local bin_count
    bin_count=$(find "$local_bin" -maxdepth 1 -type f -executable 2>/dev/null | wc -l)
    ok "Executable scripts in $local_bin: $bin_count"
  else
    warn "Local bin directory missing: $local_bin"
    ((doc_warnings++)) || true
  fi

  # Symlink Integrity Check
  local broken_links=0
  if [[ -d "$config_home" ]]; then
    while IFS= read -r -d '' symlink; do
      if [[ -L "$symlink" && ! -e "$symlink" ]]; then
        warn "Broken symlink: $symlink"
        ((broken_links++)) || true
      fi
    done < <(find "$config_home" -xtype l -print0 2>/dev/null)
  fi

  if [[ $broken_links -eq 0 ]]; then
    ok "No broken symlinks detected in $config_home"
  else
    warn "Found $broken_links broken symlink(s)"
    ((doc_warnings++)) || true
  fi
  echo ""

  # --- 5. Service Status Verification ---
  info "5. Logical Services Status ($detected_init)"
  local logical_services=(NetworkManager bluetooth sddm)

  # Load init backend if available
  export INIT_SYSTEM="$detected_init"
  local backend_script="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}/scripts/install/init/${detected_init}.sh"

  if [[ -f "$backend_script" ]]; then
    # shellcheck source=/dev/null
    source "$backend_script" 2>/dev/null || true
  fi

  for srv in "${logical_services[@]}"; do
    if declare -F service_exists >/dev/null 2>&1 && service_exists "$srv"; then
      if declare -F service_status >/dev/null 2>&1 && service_status "$srv"; then
        ok "Service $srv: Active & Verified"
      else
        info "Service $srv: Exists on system (Inactive/Disabled)"
      fi
    else
      warn "Service $srv: Not found on system"
      ((doc_warnings++)) || true
    fi
  done
  echo ""

  # --- Summary ---
  echo "=========================================="
  printf "  Errors:   %d\n" "$doc_errors"
  printf "  Warnings: %d\n" "$doc_warnings"
  echo "=========================================="

  if [[ $doc_errors -eq 0 ]]; then
    ok "Doctor diagnostics complete. System is ready."
    return 0
  else
    fail "Doctor diagnostics found $doc_errors critical error(s)."
    return 1
  fi
}

# Allow direct execution of doctor.sh
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # Source core helpers if running standalone
  DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
  export DOTFILES_DIR
  if [[ -f "$DOTFILES_DIR/scripts/utils/lib.sh" ]]; then
    # shellcheck source=/dev/null
    source "$DOTFILES_DIR/scripts/utils/lib.sh"
  else
    info() { printf "[INFO]    %s\n" "$*"; }
    ok()   { printf "[SUCCESS] %s\n" "$*"; }
    warn() { printf "[WARN]    %s\n" "$*"; }
    warning() { printf "[WARN]    %s\n" "$*"; }
    fail() { printf "[ERROR]   %s\n" "$*"; }
  fi
  run_doctor
fi
