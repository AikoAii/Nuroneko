# Packages

All packages installed by Nuroneko are listed in the `packages/` directory. The installer reads these files and installs packages automatically.

## Official Packages (`packages/arch-official.txt`)

Installed via `pacman -S --needed --noconfirm`.

### Core Utilities

| Package | Description |
|---------|-------------|
| `bash` | GNU Bourne-Again SHell |
| `coreutils` | Core GNU utilities |
| `findutils` | Find utilities |
| `gawk` | GNU AWK |
| `grep` | Pattern matching |

### Hyprland Ecosystem

| Package | Description |
|---------|-------------|
| `hyprland` | Tiling Wayland compositor |
| `hyprlock` | Screen locker |
| `hypridle` | Idle daemon |
| `hyprpicker` | Color picker |
| `hyprpaper` | Wallpaper daemon |

### Desktop Components

| Package | Description |
|---------|-------------|
| `waybar` | Status bar |
| `fuzzel` | Application launcher |
| `swaync` | Notification center |
| `wlogout` | Logout menu |
| `kanshi` | Display configuration |
| `rofi` | Versatile launcher/menu |

### Screenshot Tools

| Package | Description |
|---------|-------------|
| `grim` | Screenshot utility |
| `slurp` | Region selector |
| `satty` | Screenshot annotation |
| `flameshot` | Advanced screenshot tool |

### Clipboard

| Package | Description |
|---------|-------------|
| `wl-clipboard` | Wayland clipboard utilities |
| `cliphist` | Clipboard history manager |

### Terminal & Shell

| Package | Description |
|---------|-------------|
| `kitty` | GPU-accelerated terminal emulator |
| `fish` | Friendly interactive shell |
| `zsh` | Z shell |

### Editor & Tools

| Package | Description |
|---------|-------------|
| `neovim` | Hyperextensible text editor |
| `tmux` | Terminal multiplexer |
| `starship` | Cross-shell prompt |
| `yazi` | Terminal file manager |

### System Monitoring

| Package | Description |
|---------|-------------|
| `atuin` | Shell history manager |
| `btop` | System monitor |
| `cava` | Audio visualizer |
| `fastfetch` | System information display |

### Audio

| Package | Description |
|---------|-------------|
| `pipewire` | Audio/video server |
| `pipewire-pulse` | PulseAudio replacement |
| `wireplumber` | PipeWire session manager |
| `playerctl` | Media player controller |
| `pamixer` | PulseAudio mixer CLI |
| `pavucontrol` | PulseAudio volume control GUI |
| `brightnessctl` | Brightness controller |

### Networking

| Package | Description |
|---------|-------------|
| `networkmanager` | Network connection manager |
| `network-manager-applet` | System tray applet |

### Bluetooth

| Package | Description |
|---------|-------------|
| `bluez` | Bluetooth protocol stack |
| `bluez-utils` | Bluetooth utilities |
| `blueman` | Bluetooth manager GUI |

### System

| Package | Description |
|---------|-------------|
| `libnotify` | Desktop notifications library |
| `polkit` | Authorization framework |
| `polkit-gnome` | GNOME polkit agent |
| `dbus` | Message bus system |
| `dconf` | Low-level configuration system |
| `iproute2` | IP routing utilities |
| `iw` | Wireless tools |
| `imagemagick` | Image manipulation |
| `jq` | JSON processor |

### File Management

| Package | Description |
|---------|-------------|
| `file-roller` | Archive manager |
| `nemo` | File manager |

### Media

| Package | Description |
|---------|-------------|
| `mpv` | Video player |
| `imv` | Image viewer |

### OCR & Translation

| Package | Description |
|---------|-------------|
| `tesseract` | OCR engine |
| `translate-shell` | CLI translator |

### XDG & Portal

| Package | Description |
|---------|-------------|
| `xdg-desktop-portal` | Desktop integration portal |
| `xdg-desktop-portal-gtk` | GTK portal backend |
| `xdg-desktop-portal-hyprland` | Hyprland portal backend |
| `xdg-utils` | Desktop integration utilities |
| `qt5-wayland` | Qt5 Wayland support |
| `qt6-wayland` | Qt6 Wayland support |

### Fonts

| Package | Description |
|---------|-------------|
| `noto-fonts` | Google Noto fonts |
| `noto-fonts-cjk` | CJK font support |
| `noto-fonts-emoji` | Emoji font |
| `ttf-font-awesome` | Icon font |
| `ttf-jetbrains-mono-nerd` | JetBrains Mono Nerd Font |
| `ttf-nerd-fonts-symbols` | Nerd Fonts symbols |

### Modern CLI Tools

| Package | Description |
|---------|-------------|
| `bat` | Cat with syntax highlighting |
| `eza` | Modern ls replacement |
| `fzf` | Fuzzy finder |
| `zoxide` | Smarter cd command |
| `procs` | Modern ps replacement |
| `dust` | Modern du replacement |
| `curlie` | Modern curl frontend |
| `gping` | Ping with graph |
| `micro` | Simple terminal editor |

### Misc

| Package | Description |
|---------|-------------|
| `pacman-contrib` | Pacman helper scripts |
| `qalculate-qt` | Calculator |

---

## AUR Packages (`packages/arch-aur.txt`)

Installed via `paru` (preferred) or `yay`. If neither is available, AUR packages are skipped with a warning.

| Package | Description |
|---------|-------------|
| `hyprshade` | Hyprland shader manager |
| `swayosd` | On-screen display for volume/brightness |
| `rofimoji` | Emoji picker for rofi |
| `pokemon-colorscripts-git` | Pokemon color scripts for terminal |
| `zen-browser-bin` | Zen web browser |

## Customizing Packages

To add or remove packages, edit the corresponding file:

- `packages/arch-official.txt` — Official repository packages
- `packages/arch-aur.txt` — AUR packages

Rules:
- One package per line
- Lines starting with `#` are comments
- Blank lines are ignored
