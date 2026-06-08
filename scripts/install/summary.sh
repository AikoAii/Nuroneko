#!/usr/bin/env bash
# scripts/install/summary.sh — Display installation summary

show_install_summary() {
  step "Installation Summary"

  printf "%-32s %s\n" "Distro:" "${DISTRO:-unknown}"
  printf "%-32s %s\n" "Init System:" "${INIT_SYSTEM:-unknown}"
  printf "%-32s %s\n" "Deployment Mode:" "${DEPLOY_MODE:-copy}"

  printf "\n"

  printf "%-32s %s\n" "Official Packages Installed:" "${INSTALLED_PACKAGES:-0}"
  printf "%-32s %s\n" "Deployed Configuration Items:" "${DEPLOYED_CONFIGS:-0}"
  printf "%-32s %s\n" "Deployed Assets:" "${DEPLOYED_ASSETS:-0}"
  printf "%-32s %s\n" "Configurations Backed Up:" "${BACKED_UP_ITEMS:-0}"
  printf "%-32s %s\n" "Services Enabled:" "${ENABLED_SERVICES:-0}"

  printf "\n"

  if [[ -n "${BACKUP_LOCATION}" ]]; then
    printf "%-32s %s\n" "Backup Location:" "${BACKUP_LOCATION}"
  fi

  printf "%-32s %s\n" "Installation Warnings:" "${INSTALL_WARNINGS:-0}"
  printf "%-32s %ss\n" "Total Duration:" "${INSTALL_DURATION:-0}"

  echo ""
  ok "Installation completed successfully"
}
