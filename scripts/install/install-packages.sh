#!/usr/bin/env bash
# scripts/install/install-packages.sh — Install official and AUR packages

install_packages() {
  info "Installing packages..."

  # --- Detect privilege escalation tool ---
  local sudo_cmd=""
  if command -v sudo >/dev/null 2>&1; then
    sudo_cmd="sudo"
  elif command -v doas >/dev/null 2>&1; then
    sudo_cmd="doas"
  else
    error "Neither sudo nor doas found"
  fi

  # --- Install official packages from pacman ---
  local official_file="${DOTFILES_DIR}/packages/arch-official.txt"

  if [[ ! -f "$official_file" ]]; then
    error "Official package list not found: $official_file"
  fi

  # Read packages, filter comments and blank lines
  local -a official_packages=()
  while IFS= read -r line; do
    # Skip comments and blank lines
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$line" ]] && continue
    official_packages+=("$line")
  done <"$official_file"

  if [[ ${#official_packages[@]} -eq 0 ]]; then
    error "No packages found in: $official_file"
  fi

  info "Installing ${#official_packages[@]} official packages..."
  if ! "$sudo_cmd" pacman -S --needed --noconfirm "${official_packages[@]}"; then
    error "Failed to install official packages"
  fi
  export INSTALLED_PACKAGES=${#official_packages[@]}
  ok "Official packages installed: ${#official_packages[@]}"

  # --- Install AUR packages ---
  local aur_file="${DOTFILES_DIR}/packages/arch-aur.txt"

  if [[ ! -f "$aur_file" ]]; then
    warn "AUR package list not found: $aur_file (skipping AUR packages)"
    return 0
  fi

  # Read AUR packages, filter comments and blank lines
  local -a aur_packages=()
  while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$line" ]] && continue
    aur_packages+=("$line")
  done <"$aur_file"

  if [[ ${#aur_packages[@]} -eq 0 ]]; then
    info "No AUR packages to install"
    return 0
  fi

  # --- Detect AUR helper (prefer paru) ---
  local aur_helper=""
  if command -v paru >/dev/null 2>&1; then
    aur_helper="paru"
  elif command -v yay >/dev/null 2>&1; then
    aur_helper="yay"
  else
    warn "No AUR helper found (paru or yay). Skipping AUR packages."
    warn "Install paru or yay manually to install AUR packages"
    return 0
  fi

  info "Installing ${#aur_packages[@]} AUR packages using $aur_helper..."
  if ! "$aur_helper" -S --needed --noconfirm "${aur_packages[@]}"; then
    warn "Failed to install some AUR packages (continuing)"
  fi

  ((INSTALLED_PACKAGES += ${#aur_packages[@]})) || true
  ok "AUR packages processed: ${#aur_packages[@]}"
}
