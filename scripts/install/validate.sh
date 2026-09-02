#!/usr/bin/env bash
# scripts/install/validate.sh — Validate installation completion

validate_installation() {
  step "Validating installation..."

  local validation_errors=0
  local validation_warnings=0

  # --- Check required directories exist ---
  info "Checking deployment directories..."

  local required_dirs=(
    "${XDG_CONFIG_HOME:-$HOME/.config}"
    "$HOME/.local/bin"
    "${XDG_DATA_HOME:-$HOME/.local/share}/icons"
    "${XDG_DATA_HOME:-$HOME/.local/share}/wallpapers"
  )

  for dir in "${required_dirs[@]}"; do
    if [[ -d "$dir" ]]; then
      ok "Directory exists: $dir"
    else
      warn "Directory not found: $dir"
      ((validation_warnings++)) || true
    fi
  done

  # --- Check deployed configuration files ---
  info "Checking deployed configurations..."

  local config_dirs=(
    "${XDG_CONFIG_HOME:-$HOME/.config}"
    "$HOME/.local"
  )

  local deployed_configs=0
  for config_dir in "${config_dirs[@]}"; do
    if [[ -d "$config_dir" ]]; then
      deployed_configs=$({ find "$config_dir" -type f 2>/dev/null || true; } | wc -l | tr -d '[:space:]')
      if [[ ${deployed_configs:-0} -gt 0 ]]; then
        ok "Found $deployed_configs configuration files in $config_dir"
      else
        warn "No configuration files found in $config_dir"
        ((validation_warnings++)) || true
      fi
    fi
  done

  # --- Check deployed assets ---
  info "Checking deployed assets..."

  local icons_dir="${XDG_DATA_HOME:-$HOME/.local/share}/icons"
  local wallpapers_dir="${XDG_DATA_HOME:-$HOME/.local/share}/wallpapers"

  if [[ -d "$icons_dir" ]]; then
    local icon_count
    icon_count=$({ find "$icons_dir" -maxdepth 1 -mindepth 1 2>/dev/null || true; } | wc -l | tr -d '[:space:]')
    if [[ ${icon_count:-0} -gt 0 ]]; then
      ok "Found $icon_count icon theme(s)"
    else
      warn "No icon themes found in $icons_dir"
      ((validation_warnings++)) || true
    fi
  else
    warn "Icons directory not found: $icons_dir"
    ((validation_warnings++)) || true
  fi

  if [[ -d "$wallpapers_dir" ]]; then
    local wallpaper_count
    wallpaper_count=$({ find "$wallpapers_dir" -type f 2>/dev/null || true; } | wc -l | tr -d '[:space:]')
    if [[ ${wallpaper_count:-0} -gt 0 ]]; then
      ok "Found $wallpaper_count wallpaper(s)"
    else
      warn "No wallpapers found in $wallpapers_dir"
      ((validation_warnings++)) || true
    fi
  else
    warn "Wallpapers directory not found: $wallpapers_dir"
    ((validation_warnings++)) || true
  fi

  # --- Check executable scripts ---
  info "Checking script permissions..."

  if [[ -d "$HOME/.local/bin" ]]; then
    local executable_count=0
    local non_executable_count=0

    while IFS= read -r -d '' script; do
      if [[ -x "$script" ]]; then
        ((executable_count++)) || true
      else
        ((non_executable_count++)) || true
        warn "Script not executable: $(basename "$script")"
      fi
    done < <(find "$HOME/.local/bin" -maxdepth 1 -type f -print0 2>/dev/null)

    if [[ $executable_count -gt 0 ]]; then
      ok "$executable_count script(s) are executable"
    fi

    if [[ $non_executable_count -gt 0 ]]; then
      warn "$non_executable_count script(s) not executable"
      ((validation_warnings++)) || true
    fi
  else
    warn "Scripts directory not found: $HOME/.local/bin"
    ((validation_warnings++)) || true
  fi

  # --- Check for broken symlinks ---
  info "Checking symlink integrity..."

  local broken_symlinks=0
  while IFS= read -r -d '' symlink; do
    if [[ -L "$symlink" && ! -e "$symlink" ]]; then
      warn "Broken symlink: $symlink"
      ((broken_symlinks++)) || true
    fi
  done < <(find "${XDG_CONFIG_HOME:-$HOME/.config}" -xtype l -print0 2>/dev/null)

  if [[ $broken_symlinks -eq 0 ]]; then
    ok "No broken symlinks detected"
  else
    warn "Found $broken_symlinks broken symlink(s)"
    ((validation_warnings++)) || true
  fi

  # --- Check enabled services ---
  info "Checking logical services..."

  local -a expected_services=(
    "NetworkManager"
    "bluetooth"
    "sddm"
  )

  for service in "${expected_services[@]}"; do
    if declare -F service_exists >/dev/null 2>&1 && service_exists "$service" "system"; then
      if declare -F service_status >/dev/null 2>&1 && service_status "$service" "system"; then
        ok "Service active & enabled: $service"
      else
        info "Service exists on system: $service"
      fi
    else
      info "Service $service not installed on system (skipping validation)"
    fi
  done

  echo ""

  if [[ $validation_errors -eq 0 && $validation_warnings -eq 0 ]]; then
    ok "Installation validation passed"
  elif [[ $validation_errors -eq 0 ]]; then
    ok "Validation completed with $validation_warnings warning(s)"
  else
    warn "Validation completed with $validation_errors error(s) and $validation_warnings warning(s)"
  fi
}
