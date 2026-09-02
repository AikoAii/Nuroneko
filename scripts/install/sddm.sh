#!/usr/bin/env bash
# scripts/install/sddm.sh — Deploy and configure SDDM theme

deploy_sddm_theme() {
  info "Setting up SDDM theme (NuroPix)..."

  local theme_src="${DOTFILES_DIR}/configs/sddm/NuroPix"
  local target_dir="/usr/share/sddm/themes/NuroPix"
  local sddm_conf_dir="/etc/sddm.conf.d"
  local sddm_conf="${sddm_conf_dir}/10-theme.conf"

  if [[ ! -d "$theme_src" ]]; then
    warn "SDDM theme source not found: $theme_src (skipping SDDM theme setup)"
    return 0
  fi

  local sudo_cmd=""
  if [[ $EUID -ne 0 ]]; then
    if command -v sudo >/dev/null 2>&1; then
      sudo_cmd="sudo"
    else
      warn "Root privileges or sudo required to install SDDM theme to /usr/share/sddm/themes"
      return 0
    fi
  fi

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would execute (%s): copy SDDM theme to %s\n" "$CYAN" "$NC" "${sudo_cmd:-root}" "$target_dir"
    printf "%b[DRY-RUN]%b  would execute (%s): configure default SDDM theme in %s\n" "$CYAN" "$NC" "${sudo_cmd:-root}" "$sddm_conf"
    ok "[DRY-RUN] SDDM theme setup simulation complete"
    return 0
  fi

  if [[ -n "$sudo_cmd" ]]; then
    info "Executing privileged command (sudo) to install SDDM theme to $target_dir"
  fi

  $sudo_cmd mkdir -p "/usr/share/sddm/themes" || {
    warn "Failed to create /usr/share/sddm/themes directory"
    return 0
  }

  $sudo_cmd rm -rf "$target_dir"
  $sudo_cmd cp -r "$theme_src" "$target_dir" || {
    warn "Failed to copy SDDM theme NuroPix to $target_dir"
    return 0
  }

  info "Configuring NuroPix as default SDDM theme in $sddm_conf..."
  $sudo_cmd mkdir -p "$sddm_conf_dir"
  printf "[Theme]\nCurrent=NuroPix\n" | $sudo_cmd tee "$sddm_conf" >/dev/null || {
    warn "Failed to write SDDM configuration to $sddm_conf"
    return 0
  }

  ok "SDDM theme NuroPix deployed and configured as default"
}
