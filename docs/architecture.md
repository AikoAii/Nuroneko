# Architecture

## Design principles

1. One responsibility per layer.
2. Application-native configuration formats.
3. Portable configuration by default.
4. Small, understandable modules.
5. Safe deployment with backup and rollback.

## Directories

- `dotfiles/<package>/`: GNU Stow packages.
- `bin/`: User-facing commands installed into ~/.local/bin.
- `scripts/`: Development tools and shared shell libraries.
- `installer/`: Installation orchestration.
- `packages/`: Distribution-specific package manifests.
- `assets/`: Wallpapers, icons, cursors, fonts, and themes.
- `docs/`: Project and contributor documentation.

## Hyprland

The Hyprland Stow package lives in `dotfiles/hypr/`.

Its Lua entry point and modules will live under:

`dotfiles/hypr/.config/hypr/`

Hypridle, Hyprlock, and Hyprpaper retain their native configuration
formats unless their upstream applications provide another interface.

## User scripts vs developer scripts

- Put user-invoked commands in `bin/`.
- Put repository maintenance and testing in `scripts/`.
- Put installation logic in `installer/`.
