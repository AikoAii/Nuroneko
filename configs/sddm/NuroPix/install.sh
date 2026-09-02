#!/usr/bin/env bash

set -euo pipefail

THEME_NAME="NuroPix"
THEME_DIR="/usr/share/sddm/themes"
INSTALL_PATH="${THEME_DIR}/${THEME_NAME}"

CONFIG_FILES=(
    "/etc/sddm.conf"
    "/etc/sddm.conf.d/default.conf"
    "/etc/sddm.conf.d/kde_settings.conf"
)

if [[ $EUID -ne 0 ]]; then
    echo "Please run this installer with sudo."
    exit 1
fi

if [[ ! -d "$THEME_DIR" ]]; then
    echo "SDDM themes directory not found:"
    echo "  $THEME_DIR"
    exit 1
fi

echo "Installing ${THEME_NAME}..."

rm -rf "$INSTALL_PATH"
mkdir -p "$INSTALL_PATH"

rsync -a \
    --exclude ".git" \
    --exclude ".github" \
    --exclude "README.md" \
    --exclude "LICENSE" \
    --exclude "install.sh" \
    --exclude "uninstall.sh" \
    ./ "$INSTALL_PATH"

echo "Installed successfully."

if [[ "${1:-}" == "--current" ]]; then
    for config in "${CONFIG_FILES[@]}"; do
        [[ -f "$config" ]] || continue

        if grep -q "^Current=" "$config"; then
            sed -i "s/^Current=.*/Current=${THEME_NAME}/" "$config"
        else
            printf "\n[Theme]\nCurrent=%s\n" "$THEME_NAME" >> "$config"
        fi

        echo "Current theme set to ${THEME_NAME}."
        break
    done
fi

echo
echo "Done."
