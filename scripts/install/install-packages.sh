#!/usr/bin/env bash
# scripts/install/install-packages.sh — Install official and AUR packages

install_packages() {
  info "Installing packages..."

  local privilege_cmd=""
  if [[ $EUID -ne 0 ]]; then
    if command -v sudo >/dev/null 2>&1; then
      privilege_cmd="sudo"
    elif command -v doas >/dev/null 2>&1; then
      privilege_cmd="doas"
    else
      error "Neither sudo nor doas found (Privilege escalation required for package installation)"
    fi
  fi

  # --- Official pacman packages ---
  local official_file="${DOTFILES_DIR}/packages/arch-official.txt"

  if [[ ! -f "$official_file" ]]; then
    error "Official package list not found: $official_file"
  fi

  local -a official_packages=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue
    official_packages+=("$line")
  done <"$official_file"

  if [[ ${#official_packages[@]} -eq 0 ]]; then
    error "No packages found in: $official_file"
  fi

  info "Installing ${#official_packages[@]} official packages via pacman..."
  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would execute ($privilege_cmd): pacman -S --needed --noconfirm %s package(s)\n" "$CYAN" "$NC" "${#official_packages[@]}"
  else
    if [[ -n "$privilege_cmd" ]]; then
      info "Executing privileged command ($privilege_cmd) to install packages via pacman"
    fi
    if ! $privilege_cmd pacman -S --needed --noconfirm "${official_packages[@]}"; then
      error "Failed to install official pacman packages"
    fi
  fi

  export INSTALLED_PACKAGES=${#official_packages[@]}
  ok "Official packages processed: ${#official_packages[@]}"

  # --- AUR packages ---
  local aur_file="${DOTFILES_DIR}/packages/arch-aur.txt"

  if [[ ! -f "$aur_file" ]]; then
    warn "AUR package list not found: $aur_file (skipping AUR packages)"
    return 0
  fi

  local -a aur_packages=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue
    aur_packages+=("$line")
  done <"$aur_file"

  if [[ ${#aur_packages[@]} -eq 0 ]]; then
    info "No AUR packages to install"
    return 0
  fi

  local aur_helper=""
  if command -v yay >/dev/null 2>&1; then
    aur_helper="yay"
  elif command -v paru >/dev/null 2>&1; then
    aur_helper="paru"
  else
    warn "No AUR helper (yay or paru) found. Skipping AUR packages."
    return 0
  fi

  info "Installing ${#aur_packages[@]} AUR packages using $aur_helper..."
  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would execute: %s -S --needed --noconfirm %s package(s)\n" "$CYAN" "$NC" "$aur_helper" "${#aur_packages[@]}"
  else
    if ! "$aur_helper" -S --needed --noconfirm "${aur_packages[@]}"; then
      warn "Failed to install some AUR packages (continuing)"
    fi
  fi

  ((INSTALLED_PACKAGES += ${#aur_packages[@]})) || true
  ok "AUR packages processed: ${#aur_packages[@]}"
}
