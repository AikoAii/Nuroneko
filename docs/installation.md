# Installation Guide

## Prerequisites

- **Arch Linux** or **Artix Linux** (other distributions are not supported)
- **pacman** package manager
- **sudo** or **doas** for privilege escalation
- **git** for cloning the repository
- Internet connection (for package installation)

### Optional

- **paru** or **yay** for AUR packages (the installer will warn if neither is found)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/AikoAii/nuroneko.git
cd nuroneko
```

### 2. Run the Installer

#### Default Mode (Copy)

```bash
./install.sh
```

Files are copied from the repository to their target locations. This is the recommended mode for most users.

#### Symlink Mode

```bash
./install.sh --symlink
```

Creates symbolic links from target locations back to the repository. Useful during development — editing files in the repo immediately updates the live configuration.

### 3. Post-Installation

After installation completes:

1. **Log out and log back in** for all changes to take effect
2. If using tmux, press `prefix + I` (default: `Ctrl-Space + I`) to install tmux plugins via TPM
3. Open Fish shell and run `fisher update` if you need to refresh Fish plugins

## What Gets Deployed

### Configuration Files (`~/.config/`)

| Component | Description |
|-----------|-------------|
| `btop/` | System monitor configuration |
| `cava/` | Audio visualizer |
| `fastfetch/` | System information display |
| `fish/` | Fish shell (config, plugins, aliases, functions) |
| `hypr/` | Hyprland compositor (keybindings, appearance, rules) |
| `kanshi/` | Display configuration |
| `nvim/` | Neovim editor |
| `rofi/` | Application launcher |
| `starship.toml` | Cross-shell prompt |
| `swaync/` | Notification center |
| `tmux/` | Terminal multiplexer |
| `waybar/` | Status bar |
| `wlogout/` | Logout menu |
| `yazi/` | Terminal file manager |
| `zsh/` | Zsh shell configuration |

### Home Directory Files (`~/`)

| File | Description |
|------|-------------|
| `.bash_profile` | Bash login shell profile (starts Hyprland on tty1) |
| `.bashrc` | Bash interactive shell configuration |
| `.bash_logout` | Bash logout hook |
| `.tmux.conf` | Tmux configuration with TPM plugin management |
| `.xprofile` | D-Bus session launcher |
| `.face` | User avatar |

### Scripts (`~/.local/bin/`)

Various utility scripts for system management:

- `battery.sh` — Battery status for Waybar
- `bluetooth.sh` — Bluetooth toggle
- `brightness.sh` — Brightness control
- `screenshot.sh` — Screenshot utility
- `volume.sh` — Volume control
- `wallpaper-*.sh` — Wallpaper management
- And more...

### Assets

| Type | Source | Destination |
|------|--------|-------------|
| Icons | `assets/icons/` | `~/.local/share/icons/` |
| Wallpapers | `assets/wallpapers/` | `~/.local/share/wallpapers/` |

## Uninstallation

The installer creates a timestamped backup before deploying. To restore:

1. Find your backup in `~/.local/share/nuroneko/backups/`
2. Check the `MANIFEST.txt` for a list of backed-up items
3. Copy the backed-up items back to their original locations

There is no automated uninstall script — the backup manifest serves as a restore guide.
