#!/usr/bin/env bash
# scripts/install/checks.sh — Pre-flight validation

run_checks() {
  step "Running pre-flight checks..."

  # --- Not running as root ---
  if [[ $EUID -eq 0 ]]; then
    error "Do not run this installer as root or with sudo"
  fi
  ok "Not running as root"

  # --- Linux OS check ---
  if [[ "$OSTYPE" != linux* ]]; then
    error "Unsupported OS: $OSTYPE (Linux required)"
  fi
  ok "OS: Linux"

  # --- Required commands check ---
  local required_cmds=(
    bash
    git
    ln
    mkdir
    chmod
    mv
    find
    grep
    basename
    date
    sed
    readlink
  )

  info "Checking required commands..."
  for cmd in "${required_cmds[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      error "Required command not found: $cmd"
    fi
  done
  ok "All required commands available"

  # --- Sudo or doas access ---
  local privilege_escalation=""
  if command -v sudo >/dev/null 2>&1; then
    privilege_escalation="sudo"
  elif command -v doas >/dev/null 2>&1; then
    privilege_escalation="doas"
  else
    error "Neither sudo nor doas found"
  fi
  ok "Privilege escalation available: $privilege_escalation"

  # --- Pacman package manager check (Required for current Arch/Artix target) ---
  if ! command -v pacman >/dev/null 2>&1; then
    error "pacman package manager not found (Required for Arch/Artix targets)"
  fi
  ok "Package manager: pacman available"

  # --- Optional helper checks (Warnings only, non-fatal) ---
  info "Checking optional helpers..."
  if command -v yay >/dev/null 2>&1 || command -v paru >/dev/null 2>&1; then
    ok "AUR helper available"
  else
    warn "No AUR helper (yay or paru) found. AUR packages will be skipped if requested."
  fi

  if command -v whiptail >/dev/null 2>&1; then
    ok "TUI engine: whiptail available"
  elif command -v dialog >/dev/null 2>&1; then
    ok "TUI engine: dialog available"
  else
    info "No whiptail or dialog found; using clean Bash CLI menu"
  fi

  # --- Internet connectivity (optional) ---
  if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    warn "No internet connection detected (package downloads may fail)"
  else
    ok "Internet connectivity confirmed"
  fi

  # --- Create/verify required repository directories ---
  local required_dirs=(
    "${DOTFILES_DIR}"
    "${DOTFILES_DIR}/configs"
    "${DOTFILES_DIR}/assets"
    "${DOTFILES_DIR}/packages"
    "${DOTFILES_DIR}/scripts"
  )

  info "Checking required repository structure..."
  for dir in "${required_dirs[@]}"; do
    if [[ ! -d "$dir" ]]; then
      error "Required repository directory missing: $dir"
    fi
  done
  ok "Repository structure verified"

  # --- Check package files ---
  local official_pkg_file="${DOTFILES_DIR}/packages/arch-official.txt"
  if [[ ! -f "$official_pkg_file" ]]; then
    error "Package list missing: $official_pkg_file"
  fi
  ok "Package list found: arch-official.txt"

  # --- XDG directories (create if needed) ---
  ensure_dir "${XDG_CONFIG_HOME:-$HOME/.config}"
  ensure_dir "${XDG_DATA_HOME:-$HOME/.local/share}"
  ensure_dir "$HOME/.local/bin"
  ok "XDG base directories ready"

  ok "Pre-flight checks passed"
}
