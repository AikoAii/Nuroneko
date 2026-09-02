#!/usr/bin/env bash
# scripts/install/permissions.sh — Set executable permissions on scripts

set_permissions() {
  info "Setting executable permissions..."

  local bin_dir="$HOME/.local/bin"

  if [[ ! -d "$bin_dir" ]]; then
    warn "Directory does not exist: $bin_dir (skipping permissions)"
    return 0
  fi

  info "Making scripts in $bin_dir executable..."

  local script_count=0
  while IFS= read -r -d '' script; do
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      ((script_count++)) || true
    else
      if chmod +x "$script"; then
        ((script_count++)) || true
      fi
    fi
  done < <(find "$bin_dir" -maxdepth 1 -type f -print0 2>/dev/null)

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    ok "[DRY-RUN] Simulation: $script_count script(s) in $bin_dir would be set executable"
  else
    if [[ $script_count -gt 0 ]]; then
      ok "Made $script_count script(s) executable"
    else
      info "No scripts found in $bin_dir"
    fi
  fi
}
