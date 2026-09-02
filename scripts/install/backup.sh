#!/usr/bin/env bash
# scripts/install/backup.sh — Safe backup of existing configurations

backup_configs() {
  info "Checking for existing configurations to back up..."

  local backup_base="${XDG_DATA_HOME:-$HOME/.local/share}/nuroneko/backups"
  local timestamp
  timestamp=$(date +%Y-%m-%d_%H-%M-%S)
  local backup_dir="$backup_base/$timestamp"

  local has_backup=false
  local backup_count=0
  local targets_to_check=()

  # Auto-discover targets
  if [[ -d "${DOTFILES_DIR}/configs/.config" ]]; then
    for src in "${DOTFILES_DIR}/configs/.config"/*; do
      [[ -e "$src" ]] || continue
      local name
      name=$(basename "$src")
      targets_to_check+=("${XDG_CONFIG_HOME:-$HOME/.config}/$name")
    done
  fi

  if [[ -d "${DOTFILES_DIR}/configs/.local" ]]; then
    for src in "${DOTFILES_DIR}/configs/.local"/*; do
      [[ -e "$src" ]] || continue
      local name
      name=$(basename "$src")
      targets_to_check+=("$HOME/.local/$name")
    done
  fi

  if [[ -d "${DOTFILES_DIR}/configs/home" ]]; then
    for src in "${DOTFILES_DIR}/configs/home"/*; do
      [[ -e "$src" ]] || continue
      local name
      name=$(basename "$src")
      targets_to_check+=("$HOME/$name")
    done
  fi

  for target in "${targets_to_check[@]}"; do
    if [[ -e "$target" || -L "$target" ]]; then
      local target_name
      target_name=$(basename "$target")

      if [[ "${DRY_RUN:-false}" == "true" ]]; then
        printf "%b[DRY-RUN]%b  would backup: %s -> %s/\n" "$CYAN" "$NC" "$target" "$backup_dir"
        ((backup_count++)) || true
        has_backup=true
        continue
      fi

      if [[ "$has_backup" == false ]]; then
        ensure_dir "$backup_dir"
        has_backup=true
      fi

      info "Backing up: $target_name"
      if mv "$target" "$backup_dir/"; then
        ((backup_count++)) || true
        ((BACKED_UP_ITEMS++)) || true
        ok "Backed up: $target_name"
      else
        error "Failed to backup: $target_name"
      fi
    fi
  done

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    if [[ "$has_backup" == true ]]; then
      ok "[DRY-RUN] Simulation: $backup_count item(s) would be backed up to $backup_dir"
    else
      info "[DRY-RUN] Simulation: No existing configuration files need backup"
    fi
    return 0
  fi

  if [[ "$has_backup" == true ]]; then
    {
      echo "# Nuroneko Backup Manifest"
      echo "# Created: $(date)"
      echo "# Restore with: cp -r $backup_dir/* ~/"
      echo ""
      for item in "$backup_dir"/*; do
        [[ -e "$item" ]] && echo "$(basename "$item")"
      done
    } >"$backup_dir/MANIFEST.txt"

    ok "Backup completed successfully"
    info "Backup location: $backup_dir"
    info "Items backed up: $backup_count"
    export BACKUP_LOCATION="$backup_dir"
  else
    info "No existing configurations required backup"
    export BACKUP_LOCATION=""
  fi
}
