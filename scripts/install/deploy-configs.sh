#!/usr/bin/env bash
# scripts/install/deploy-configs.sh — Deploy configuration files

deploy_configs() {
  local deploy_mode="${DEPLOY_MODE:-copy}"

  info "Deploying configuration files (mode: $deploy_mode)..."

  # --- Deploy ~/.config/* ---
  if [[ -d "${DOTFILES_DIR}/configs/.config" ]]; then
    info "Deploying ~/.config configurations..."
    ensure_dir "${XDG_CONFIG_HOME:-$HOME/.config}"

    for src in "${DOTFILES_DIR}/configs/.config"/*; do
      [[ -e "$src" ]] || continue
      local name
      name=$(basename "$src")
      local dst="${XDG_CONFIG_HOME:-$HOME/.config}/$name"

      if [[ "$deploy_mode" == "symlink" ]]; then
        if safe_symlink "$src" "$dst"; then
          info "Symlinked: .config/$name"
          ((DEPLOYED_CONFIGS++)) || true
        fi
      else
        if [[ -e "$dst" || -L "$dst" ]]; then
          warn "Target exists, skipping: .config/$name (use backup if you need restore)"
        else
          if [[ "${DRY_RUN:-false}" == "true" ]]; then
            printf "%b[DRY-RUN]%b  would copy: %s -> %s\n" "$CYAN" "$NC" "$src" "$dst"
          else
            cp -r "$src" "$dst" || error "Failed to copy: .config/$name"
            info "Copied: .config/$name"
          fi
          ((DEPLOYED_CONFIGS++)) || true
        fi
      fi
    done
    ok "~/.config configurations processed"
  fi

  # --- Deploy ~/.local/* ---
  if [[ -d "${DOTFILES_DIR}/configs/.local" ]]; then
    info "Deploying ~/.local configurations..."
    ensure_dir "$HOME/.local"

    for src in "${DOTFILES_DIR}/configs/.local"/*; do
      [[ -e "$src" ]] || continue
      local name
      name=$(basename "$src")
      local dst="$HOME/.local/$name"

      if [[ "$deploy_mode" == "symlink" ]]; then
        if safe_symlink "$src" "$dst"; then
          info "Symlinked: .local/$name"
          ((DEPLOYED_CONFIGS++)) || true
        fi
      else
        if [[ -e "$dst" || -L "$dst" ]]; then
          warn "Target exists, skipping: .local/$name"
        else
          if [[ "${DRY_RUN:-false}" == "true" ]]; then
            printf "%b[DRY-RUN]%b  would copy: %s -> %s\n" "$CYAN" "$NC" "$src" "$dst"
          else
            cp -r "$src" "$dst" || error "Failed to copy: .local/$name"
            info "Copied: .local/$name"
          fi
          ((DEPLOYED_CONFIGS++)) || true
        fi
      fi
    done
    ok "~/.local configurations processed"
  fi

  # --- Deploy home files (directly into ~/) ---
  if [[ -d "${DOTFILES_DIR}/configs/home" ]]; then
    info "Deploying home directory files..."

    for src in "${DOTFILES_DIR}/configs/home"/*; do
      [[ -e "$src" ]] || continue
      local name
      name=$(basename "$src")
      local dst="$HOME/$name"

      if [[ "$deploy_mode" == "symlink" ]]; then
        if safe_symlink "$src" "$dst"; then
          info "Symlinked: ~/$name"
          ((DEPLOYED_CONFIGS++)) || true
        fi
      else
        if [[ -e "$dst" || -L "$dst" ]]; then
          warn "Target exists, skipping: ~/$name"
        else
          if [[ "${DRY_RUN:-false}" == "true" ]]; then
            printf "%b[DRY-RUN]%b  would copy: %s -> %s\n" "$CYAN" "$NC" "$src" "$dst"
          else
            cp -r "$src" "$dst" || error "Failed to copy: ~/$name"
            info "Copied: ~/$name"
          fi
          ((DEPLOYED_CONFIGS++)) || true
        fi
      fi
    done
    ok "Home directory files processed"
  fi

  ok "Configuration deployment complete"
}
