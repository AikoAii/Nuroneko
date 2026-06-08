#!/usr/bin/env bash
# scripts/install/finalize.sh — Finalize installation

finalize_install() {
  step "Finalizing installation..."

  # --- Bootstrap TPM (Tmux Plugin Manager) ---
  local tpm_dir="$HOME/.tmux/plugins/tpm"

  if [[ ! -d "$tpm_dir" ]]; then
    info "Installing Tmux Plugin Manager (TPM)..."

    if command -v git >/dev/null 2>&1; then
      if git clone https://github.com/tmux-plugins/tpm "$tpm_dir" >/dev/null 2>&1; then
        ok "TPM installed: $tpm_dir"

        # Auto-install tmux plugins if tmux is available
        if command -v tmux >/dev/null 2>&1; then
          info "Installing tmux plugins..."
          "$tpm_dir/bin/install_plugins" >/dev/null 2>&1 && \
            ok "Tmux plugins installed" || \
            warn "Failed to install tmux plugins (run prefix + I inside tmux)"
        fi
      else
        warn "Failed to clone TPM (check internet connection)"
        warn "Install manually: git clone https://github.com/tmux-plugins/tpm $tpm_dir"
      fi
    else
      warn "git not found, cannot install TPM"
    fi
  else
    ok "TPM already installed"
  fi

  # Configurations have been deployed via copy or symlink
  # The next user login or display server restart will pick up changes

  ok "Installation finalization complete"
}
