#!/usr/bin/env bash
# scripts/install/permissions.sh — Set executable permissions on scripts

set_permissions() {
  info "Setting executable permissions..."

  local bin_dir="$HOME/.local/bin"

  # Handle missing directory gracefully
  if [[ ! -d "$bin_dir" ]]; then
    warn "Directory does not exist: $bin_dir (skipping permissions)"
    return 0
  fi

  info "Making scripts in $bin_dir executable..."

  # Only set permissions on actual scripts in ~/.local/bin
  local script_count=0
  while IFS= read -r -d '' script; do
    if chmod +x "$script"; then
      ((script_count++)) || true
    fi
  done < <(find "$bin_dir" -maxdepth 1 -type f -print0)

  if [[ $script_count -gt 0 ]]; then
    ok "Made $script_count scripts executable"
  else
    info "No scripts found in $bin_dir"
  fi
}
