#!/usr/bin/env bash
# scripts/install/backup.sh — Safe backup of existing configurations

backup_configs() {
  info "Backing up existing configurations..."

  local backup_base="${XDG_DATA_HOME:-$HOME/.local/share}/nuroneko/backups"
  local timestamp
  timestamp=$(date +%Y-%m-%d_%H-%M-%S)
  local backup_dir="$backup_base/$timestamp"

  local has_backup=false
  local backup_count=0

  # --- Auto-discover targets from repository ---
  # We'll back up any existing items that would be replaced by deployment

  local targets_to_check=()

  # Check .config items
  if [[ -d "${DOTFILES_DIR}/configs/.config" ]]; then
    for src in "${DOTFILES_DIR}/configs/.config"/*; do
      [[ -e "$src" ]] || continue
      local name
      name=$(basename "$src")
      targets_to_check+=("${XDG_CONFIG_HOME:-$HOME/.config}/$name")
    done
  fi

  # Check .local items
  if [[ -d "${DOTFILES_DIR}/configs/.local" ]]; then
    for src in "${DOTFILES_DIR}/configs/.local"/*; do
      [[ -e "$src" ]] || continue
      local name
      name=$(basename "$src")
      targets_to_check+=("$HOME/.local/$name")
    done
  fi

  # Check home items
  if [[ -d "${DOTFILES_DIR}/configs/home" ]]; then
    for src in "${DOTFILES_DIR}/configs/home"/*; do
      [[ -e "$src" ]] || continue
      local name
      name=$(basename "$src")
      targets_to_check+=("$HOME/$name")
    done
  fi

  # --- Backup existing targets ---
  for target in "${targets_to_check[@]}"; do
    if [[ -e "$target" || -L "$target" ]]; then
      # Lazy-create backup directory only when needed
      if [[ "$has_backup" == false ]]; then
        ensure_dir "$backup_dir"
        has_backup=true
      fi

      local target_name
      target_name=$(basename "$target")
      info "Backing up: $target_name"

      if mv "$target" "$backup_dir/"; then
        ((backup_count++))
        ((BACKED_UP_ITEMS++)) || true
        ok "Backed up: $target_name"
      else
        error "Failed to backup: $target_name"
      fi
    fi
  done

  # --- Create manifest ---
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
