<p align="center">
  <img src=".meta/assets/logo.png" width="75%" alt="Nuroneko Shell Banner">
</p>

<h1 align="center">Nuroneko</h1>

<p align="center">
  A modular and aesthetic Hyprland environment for Arch & Artix Linux.
</p>

<p align="center">
  Wayland-native • Cross-init • Keyboard-driven • Maintainable
</p>

<p align="center">
  <a href="#preview">Preview</a> •
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#repository-structure">Structure</a> •
  <a href="#keybindings">Keybindings</a>
</p>

---

## Preview

<p align="center">
  <img src=".meta/assets/desktop.png" width="100%" alt="Desktop">
</p>

<p align="center">
  <img src=".meta/assets/rofi.png" width="32%" alt="Rofi">
  <img src=".meta/assets/wallpaper.png" width="32%" alt="Wallpaper">
  <img src=".meta/assets/keybinds.png" width="32%" alt="Keybinds">
</p>

## Features

- **Modular architecture** — Organized configuration structure for easy maintenance
- **Hyprland** — Wayland compositor with custom keybindings, rules, and workflow enhancements
- **Fish & Zsh** — Shell configurations with aliases, functions, and modern CLI tooling
- **Waybar** — Customized status bar with integrated system modules
- **Rofi** — Application launcher and utility menus
- **Kitty** — GPU-accelerated terminal emulator
- **Nemo** — File Manager
- **SwayNC & SwayOSD** — Notifications and on-screen display integration
- **Cross-init support** — Compatible with systemd, OpenRC, runit, and dinit
- **Backup-aware installer** — Existing configurations are preserved automatically
- **Symlink deployment mode** — Development-friendly workflow
- **Catppuccin Mocha** — Consistent theming across the desktop


## Core Components

| Component        | Application            |
| ---------------- | ---------------------- |
| Window Manager   | Hyprland               |
| Status Bar       | Waybar                 |
| Launcher         | Rofi Wayland           |
| Terminal         | Kitty                  |
| Shell            | Fish / Zsh             |
| Notifications    | SwayNC                 |
| OSD              | SwayOSD                |
| File Manager     | Nemo / Yazi            |
| Audio Stack      | PipeWire + WirePlumber |
| System Utilities | Fastfetch, Btop, Cava  |

## Supported Systems

| Distribution | Init Systems         |
| ------------ | -------------------- |
| Arch Linux   | systemd              |
| Artix Linux  | OpenRC, runit, dinit |

## Installation

```bash
git clone https://github.com/AikoAii/nuroneko.git ~/.config/nuroneko
cd ~/.config/nuroneko

# Default installation
./install.sh

# Development mode
./install.sh --symlink
```

## What the Installer Does

1. **Detects distribution** — Arch Linux or Artix Linux
2. **Detects init system** — systemd, OpenRC, runit, or dinit
3. **Installs required packages**
4. **Creates automatic backups**
5. **Deploys configurations safely**
6. **Applies symlinks when requested**
7. **Configures supported services**
8. **Sets script permissions**
9. **Reloads supported components**
10. **Validates installation results**

For Arch and Artix Linux users, using an AUR helper such as `yay` or `paru` is recommended.

## Repository Structure

```text
nuroneko/
├── install.sh
├── configs/        # User configurations
├── scripts/        # Installer modules and helpers
├── packages/       # Package manifests
├── docs/           # Documentation
├── themes/         # Shared themes and assets
└── .meta/          # Branding resources
```

## Documentation

- Installation Guide
- Troubleshooting
- Package Reference
- Repository Structure
- Development Guide

## Deployment Modes

| Mode    | Command                  | Behavior                                          |
| ------- | ------------------------ | ------------------------------------------------- |
| Copy    | `./install.sh`           | Copies files to target locations                  |
| Symlink | `./install.sh --symlink` | Creates symbolic links pointing to the repository |

**Copy mode** is recommended for most users.

**Symlink mode** is intended for development and configuration iteration.

## Backup

Before deploying, the installer automatically backs up existing configurations:

```text
~/.local/share/nuroneko/backups/YYYY-MM-DD_HH-MM-SS/
```

Each backup contains a manifest describing all affected files.

## Keybindings

The workflow is designed around the `SUPER` modifier.

Useful references:

```text
docs/keybinds.md
SUPER + /
```

## Development

Useful commands:

```bash
# Validate repository
./scripts/lint.sh

# Standard installation
./install.sh

# Development mode
./install.sh --symlink
```

## Credits

- Hyprland
- Catppuccin
- Waybar
- Fuzzel
- Kitty

## License

MIT license
