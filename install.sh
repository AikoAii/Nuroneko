#!/usr/bin/env bash
set -Eeuo pipefail

# ========================================================
# Nuroneko Installer - Main Entry Point
# ========================================================

# Get the directory where install.sh is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTFILES_DIR
export DOTFILES_DIR

# Track installation metrics
readonly INSTALL_START_TIME="$(date +%s)"
export INSTALL_START_TIME

export INSTALLED_PACKAGES=0
export DEPLOYED_CONFIGS=0
export DEPLOYED_ASSETS=0
export BACKED_UP_ITEMS=0
export ENABLED_SERVICES=0
export INSTALL_WARNINGS=0
export BACKUP_LOCATION=""
export DEPLOY_MODE="copy"

# Determine deployment mode from command-line arguments
if [[ "${1:-}" == "--symlink" ]]; then
  export DEPLOY_MODE="symlink"
fi

# Source shared library functions
# shellcheck source=/dev/null
source "${DOTFILES_DIR}/scripts/utils/lib.sh" || {
  echo "FATAL: Failed to source library" >&2
  exit 1
}

# Set up error handling
trap 'error "Installation failed in ${BASH_SOURCE[1]} at line ${BASH_LINENO[0]}: ${BASH_COMMAND}"' ERR

# Require critical functions from lib.sh
require_function() {
  declare -F "$1" >/dev/null 2>&1 || {
    error "Missing required function: $1"
  }
}

require_function info
require_function warn
require_function error
require_function ok
require_function step
require_function ensure_dir
require_function safe_symlink

# Display installation banner
step "Nuroneko Dotfiles Installer"
info "Source: ${DOTFILES_DIR}"
info "Deployment mode: ${DEPLOY_MODE}"

# ========================================================
# Module Loading
# ========================================================

safe_source() {
  local file="$1"

  [[ -f "$file" ]] || error "Missing required module: $file"

  # shellcheck source=/dev/null
  source "$file" || error "Failed to source module: $file"
}

# Load all installer modules
safe_source "${DOTFILES_DIR}/scripts/install/checks.sh"
safe_source "${DOTFILES_DIR}/scripts/install/detect-distro.sh"
safe_source "${DOTFILES_DIR}/scripts/install/init/detect-init.sh"
safe_source "${DOTFILES_DIR}/scripts/install/install-packages.sh"
safe_source "${DOTFILES_DIR}/scripts/install/backup.sh"
safe_source "${DOTFILES_DIR}/scripts/install/deploy-configs.sh"
safe_source "${DOTFILES_DIR}/scripts/install/deploy-assets.sh"
safe_source "${DOTFILES_DIR}/scripts/install/services.sh"
safe_source "${DOTFILES_DIR}/scripts/install/permissions.sh"
safe_source "${DOTFILES_DIR}/scripts/install/finalize.sh"
safe_source "${DOTFILES_DIR}/scripts/install/validate.sh"
safe_source "${DOTFILES_DIR}/scripts/install/summary.sh"

# Verify all required functions exist
require_function run_checks
require_function detect_distro
require_function detect_init
require_function install_packages
require_function backup_configs
require_function deploy_configs
require_function deploy_assets
require_function enable_services
require_function set_permissions
require_function finalize_install
require_function validate_installation
require_function show_install_summary

# ========================================================
# Execution
# ========================================================

run_step() {
  local fn="$1"
  require_function "$fn"

  "$fn" || error "Step failed: $fn"
}

# Execute installation steps in order
run_step run_checks
run_step detect_distro
run_step detect_init
run_step install_packages
run_step backup_configs
run_step deploy_configs
run_step deploy_assets
run_step enable_services
run_step set_permissions
run_step finalize_install
run_step validate_installation

# ========================================================
# Completion
# ========================================================

readonly INSTALL_END_TIME="$(date +%s)"
readonly INSTALL_DURATION="$((INSTALL_END_TIME - INSTALL_START_TIME))"
export INSTALL_DURATION

run_step show_install_summary

echo ""
ok "Installation complete"
info "Log out and log back in for changes to take effect"
