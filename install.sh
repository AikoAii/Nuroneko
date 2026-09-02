#!/usr/bin/env bash
# ========================================================
# Nuroneko Installer — Main Entry Point
# Architecture: Modular / Multi-Init / Safety-First
# ========================================================
set -Eeuo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTFILES_DIR
export DOTFILES_DIR

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
export DRY_RUN=false
export NON_INTERACTIVE=false

# Task Flags
export OPT_INSTALL_PACKAGES=false
export OPT_DEPLOY_CONFIGS=false
export OPT_DEPLOY_ASSETS=false
export OPT_INSTALL_SDDM=false
export OPT_ENABLE_SERVICES=false

# --- Parse CLI Arguments ---
show_help() {
  echo "Nuroneko Dotfiles Installer"
  echo ""
  echo "Usage: ./install.sh [options] [command]"
  echo ""
  echo "Commands:"
  echo "  doctor            Run system & dependency diagnostics"
  echo ""
  echo "Options:"
  echo "  --dry-run         Simulate installation without making filesystem changes"
  echo "  --symlink         Deploy dotfiles via symlinks instead of copying"
  echo "  --non-interactive Run full installation non-interactively"
  echo "  -h, --help        Show this help message"
  echo ""
}

for arg in "$@"; do
  case "$arg" in
    doctor)
      # Source doctor module & run
      # shellcheck source=/dev/null
      source "${DOTFILES_DIR}/scripts/install/doctor.sh"
      run_doctor
      exit 0
      ;;
    --dry-run)
      export DRY_RUN=true
      ;;
    --symlink)
      export DEPLOY_MODE="symlink"
      ;;
    --non-interactive)
      export NON_INTERACTIVE=true
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      ;;
  esac
done

# Source shared helpers
source "${DOTFILES_DIR}/scripts/utils/lib.sh" || {
  echo "FATAL: Failed to source library" >&2
  exit 1
}

trap 'error "Installation failed in ${BASH_SOURCE[1]} at line ${BASH_LINENO[0]}: ${BASH_COMMAND}"' ERR

safe_source() {
  local file="$1"
  [[ -f "$file" ]] || error "Missing required module: $file"
  # shellcheck source=/dev/null
  source "$file" || error "Failed to source module: $file"
}

# Load modules
safe_source "${DOTFILES_DIR}/scripts/install/checks.sh"
safe_source "${DOTFILES_DIR}/scripts/install/detect-distro.sh"
safe_source "${DOTFILES_DIR}/scripts/install/init/detect-init.sh"
safe_source "${DOTFILES_DIR}/scripts/install/install-packages.sh"
safe_source "${DOTFILES_DIR}/scripts/install/backup.sh"
safe_source "${DOTFILES_DIR}/scripts/install/deploy-configs.sh"
safe_source "${DOTFILES_DIR}/scripts/install/deploy-assets.sh"
safe_source "${DOTFILES_DIR}/scripts/install/sddm.sh"
safe_source "${DOTFILES_DIR}/scripts/install/services.sh"
safe_source "${DOTFILES_DIR}/scripts/install/permissions.sh"
safe_source "${DOTFILES_DIR}/scripts/install/finalize.sh"
safe_source "${DOTFILES_DIR}/scripts/install/validate.sh"
safe_source "${DOTFILES_DIR}/scripts/install/summary.sh"

# ========================================================
# Phase 1: Detection & Pre-flight Checks
# ========================================================
step "Phase 1: Environment Detection & Pre-flight Checks"
run_checks
detect_distro
detect_init

# ========================================================
# Phase 2: Interactive Task Selection
# ========================================================
select_components() {
  if [[ "$NON_INTERACTIVE" == true ]]; then
    OPT_INSTALL_PACKAGES=true
    OPT_DEPLOY_CONFIGS=true
    OPT_DEPLOY_ASSETS=true
    OPT_INSTALL_SDDM=true
    OPT_ENABLE_SERVICES=true
    return 0
  fi

  local tui_engine="none"
  if command -v whiptail >/dev/null 2>&1; then
    tui_engine="whiptail"
  elif command -v dialog >/dev/null 2>&1; then
    tui_engine="dialog"
  fi

  if [[ "$tui_engine" == "whiptail" || "$tui_engine" == "dialog" ]]; then
    local choice
    choice=$("$tui_engine" --title "Nuroneko Setup Wizard" --menu \
      "Target: ${DISTRO_NAME:-Linux} (${INIT_SYSTEM:-dinit})\nSelect setup mode:" \
      16 68 4 \
      "1" "Full Setup (Packages + Configs + SDDM + Services)" \
      "2" "Configs Only (Deploy ~/.config & ~/.local)" \
      "3" "Custom Task Selection" \
      "4" "Exit Installer" \
      3>&1 1>&2 2>&3) || exit 0

    case "$choice" in
      1)
        OPT_INSTALL_PACKAGES=true; OPT_DEPLOY_CONFIGS=true
        OPT_DEPLOY_ASSETS=true; OPT_INSTALL_SDDM=true; OPT_ENABLE_SERVICES=true
        ;;
      2)
        OPT_DEPLOY_CONFIGS=true; OPT_DEPLOY_ASSETS=true
        ;;
      3)
        local custom
        custom=$("$tui_engine" --title "Custom Selection" --checklist \
          "Select components to install:" 16 68 5 \
          "PKG" "Install System & Hyprland Packages" ON \
          "CFG" "Deploy Config Dotfiles (~/.config)" ON \
          "AST" "Deploy Assets (Wallpapers, Icons)" ON \
          "SDDM" "Install NuroPix SDDM Theme" ON \
          "SVC" "Enable System Services" ON \
          3>&1 1>&2 2>&3) || exit 0
        [[ "$custom" == *"PKG"* ]] && OPT_INSTALL_PACKAGES=true
        [[ "$custom" == *"CFG"* ]] && OPT_DEPLOY_CONFIGS=true
        [[ "$custom" == *"AST"* ]] && OPT_DEPLOY_ASSETS=true
        [[ "$custom" == *"SDDM"* ]] && OPT_INSTALL_SDDM=true
        [[ "$custom" == *"SVC"* ]] && OPT_ENABLE_SERVICES=true
        ;;
      *)
        info "Installation cancelled."
        exit 0
        ;;
    esac
  else
    # Simple Clean Bash CLI Menu
    echo ""
    echo "=========================================="
    echo "  Nuroneko Component Selection Menu"
    echo "=========================================="
    echo " 1) Full Installation (Packages + Configs + SDDM + Services)"
    echo " 2) Configurations Only (Dotfiles & Assets)"
    echo " 3) Custom Task Selection"
    echo " 4) Exit"
    echo "=========================================="
    read -rp "Choice [1-4]: " choice

    case "$choice" in
      1)
        OPT_INSTALL_PACKAGES=true; OPT_DEPLOY_CONFIGS=true
        OPT_DEPLOY_ASSETS=true; OPT_INSTALL_SDDM=true; OPT_ENABLE_SERVICES=true
        ;;
      2)
        OPT_DEPLOY_CONFIGS=true; OPT_DEPLOY_ASSETS=true
        ;;
      3)
        read -rp "Install packages? [y/N]: " p && [[ "$p" =~ ^[Yy]$ ]] && OPT_INSTALL_PACKAGES=true
        read -rp "Deploy config files? [Y/n]: " c && [[ ! "$c" =~ ^[Nn]$ ]] && OPT_DEPLOY_CONFIGS=true
        read -rp "Deploy assets? [Y/n]: " a && [[ ! "$a" =~ ^[Nn]$ ]] && OPT_DEPLOY_ASSETS=true
        read -rp "Install SDDM theme? [y/N]: " s && [[ "$s" =~ ^[Yy]$ ]] && OPT_INSTALL_SDDM=true
        read -rp "Enable services? [y/N]: " v && [[ "$v" =~ ^[Yy]$ ]] && OPT_ENABLE_SERVICES=true
        ;;
      *)
        info "Installation cancelled."
        exit 0
        ;;
    esac
  fi
}

select_components

# ========================================================
# Phase 3: Review Execution Summary
# ========================================================
step "Phase 3: Review Setup Options"
echo "  Distribution   : ${DISTRO_NAME:-Linux}"
echo "  Init System    : ${INIT_SYSTEM:-systemd}"
echo "  Package Manager: pacman"
echo "  Deployment Mode: ${DEPLOY_MODE}"
echo "  Backup Enabled : true"
echo "  Dry Run Mode   : ${DRY_RUN}"
echo ""
echo "Selected Components:"
[[ "$OPT_INSTALL_PACKAGES" == true ]] && echo "  [x] System Packages" || echo "  [ ] System Packages"
[[ "$OPT_DEPLOY_CONFIGS" == true ]]   && echo "  [x] Dotfiles Configurations" || echo "  [ ] Dotfiles Configurations"
[[ "$OPT_DEPLOY_ASSETS" == true ]]    && echo "  [x] Assets (Wallpapers/Icons)" || echo "  [ ] Assets (Wallpapers/Icons)"
[[ "$OPT_INSTALL_SDDM" == true ]]     && echo "  [x] SDDM Theme (NuroPix)" || echo "  [ ] SDDM Theme (NuroPix)"
[[ "$OPT_ENABLE_SERVICES" == true ]]   && echo "  [x] System Services" || echo "  [ ] System Services"
echo ""

if [[ "$NON_INTERACTIVE" == false && "$DRY_RUN" == false ]]; then
  read -rp "Proceed with execution? [Y/n]: " confirm
  if [[ "$confirm" =~ ^[Nn]$ ]]; then
    info "Installation aborted by user."
    exit 0
  fi
fi

# ========================================================
# Phase 4: Execution
# ========================================================
step "Phase 4: Execution"

if [[ "$OPT_INSTALL_PACKAGES" == true ]]; then
  install_packages
fi

if [[ "$OPT_DEPLOY_CONFIGS" == true ]]; then
  backup_configs
  deploy_configs
fi

if [[ "$OPT_DEPLOY_ASSETS" == true ]]; then
  deploy_assets
fi

if [[ "$OPT_INSTALL_SDDM" == true ]]; then
  deploy_sddm_theme
fi

if [[ "$OPT_ENABLE_SERVICES" == true ]]; then
  enable_services
fi

set_permissions
finalize_install

# ========================================================
# Phase 5: Validation & Completion
# ========================================================
step "Phase 5: Validation"
validate_installation

readonly INSTALL_END_TIME="$(date +%s)"
readonly INSTALL_DURATION="$((INSTALL_END_TIME - INSTALL_START_TIME))"
export INSTALL_DURATION

show_install_summary

echo ""
ok "Nuroneko deployment procedure completed successfully!"
info "Log out and log back in for changes to take effect."
