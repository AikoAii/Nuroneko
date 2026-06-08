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

  # --- Required commands ---
  local required_cmds=(
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

  # --- Pacman availability ---
  if ! command -v pacman >/dev/null 2>&1; then
    error "pacman not found (Arch/Artix only)"
  fi
  ok "pacman available"

  # --- Internet connectivity (optional) ---
  if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    warn "No internet connection detected (some features may be unavailable)"
  else
    ok "Internet connectivity confirmed"
  fi

  # --- Create/verify required directories ---
  local required_dirs=(
    "${DOTFILES_DIR}"
    "${DOTFILES_DIR}/configs"
    "${DOTFILES_DIR}/assets"
    "${DOTFILES_DIR}/packages"
    "${DOTFILES_DIR}/scripts"
  )

  info "Checking required directories..."
  for dir in "${required_dirs[@]}"; do
    if [[ ! -d "$dir" ]]; then
      error "Required directory not found: $dir"
    fi
  done
  ok "All required directories exist"

  # --- Check required package files ---
  local required_files=(
    "${DOTFILES_DIR}/packages/arch-official.txt"
    "${DOTFILES_DIR}/packages/arch-aur.txt"
  )

  info "Checking required package lists..."
  for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
      error "Required file not found: $file"
    fi
  done
  ok "All required package lists found"

  # --- XDG directories (create if needed) ---
  ensure_dir "${XDG_CONFIG_HOME:-$HOME/.config}"
  ensure_dir "${XDG_DATA_HOME:-$HOME/.local/share}"
  ensure_dir "$HOME/.local/bin"
  ok "XDG directories ready"

  ok "Pre-flight checks passed"
}
