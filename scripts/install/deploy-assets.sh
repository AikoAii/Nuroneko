#!/usr/bin/env bash
# scripts/install/deploy-assets.sh — Deploy icons and wallpapers

deploy_assets() {
  local deploy_mode="${DEPLOY_MODE:-copy}"

  info "Deploying assets (mode: $deploy_mode)..."

  # --- Deploy icons ---
  if [[ -d "${DOTFILES_DIR}/assets/icons" ]]; then
    info "Deploying icons..."

    local icons_dest="${XDG_DATA_HOME:-$HOME/.local/share}/icons"
    ensure_dir "$icons_dest"

    for src in "${DOTFILES_DIR}/assets/icons"/*; do
      [[ -e "$src" ]] || continue

      local name
      name=$(basename "$src")
      local dst="$icons_dest/$name"

      if [[ "$deploy_mode" == "symlink" ]]; then
        # Symlink mode
        if safe_symlink "$src" "$dst"; then
          info "Symlinked icon: $name"
          ((DEPLOYED_ASSETS++)) || true
        fi
      else
        # Copy mode (default)
        if [[ -e "$dst" || -L "$dst" ]]; then
          warn "Icon exists, skipping: $name"
        else
          cp -r "$src" "$dst" || error "Failed to copy icon: $name"
          info "Copied icon: $name"
          ((DEPLOYED_ASSETS++)) || true
        fi
      fi
    done

    ok "Icons deployed"
  fi

  # --- Deploy wallpapers ---
  if [[ -d "${DOTFILES_DIR}/assets/wallpapers" ]]; then
    info "Deploying wallpapers..."

    local wallpapers_dest="${XDG_DATA_HOME:-$HOME/.local/share}/wallpapers"
    ensure_dir "$wallpapers_dest"

    for src in "${DOTFILES_DIR}/assets/wallpapers"/*; do
      [[ -e "$src" ]] || continue

      local name
      name=$(basename "$src")
      local dst="$wallpapers_dest/$name"

      if [[ "$deploy_mode" == "symlink" ]]; then
        # Symlink mode
        if safe_symlink "$src" "$dst"; then
          info "Symlinked wallpaper: $name"
          ((DEPLOYED_ASSETS++)) || true
        fi
      else
        # Copy mode (default)
        if [[ -e "$dst" || -L "$dst" ]]; then
          warn "Wallpaper exists, skipping: $name"
        else
          cp "$src" "$dst" || error "Failed to copy wallpaper: $name"
          info "Copied wallpaper: $name"
          ((DEPLOYED_ASSETS++)) || true
        fi
      fi
    done

    ok "Wallpapers deployed"
  fi

  ok "Asset deployment complete"
}
