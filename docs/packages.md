# Package Reference

Nuroneko installs packages from manifests located in the `packages/` directory.

The installer reads these files and installs packages automatically during deployment.

---

## Package Sources

| File                | Description                                  |
| ------------------- | -------------------------------------------- |
| `arch-official.txt` | Packages from the official Arch repositories |
| `arch-aur.txt`      | Packages from the Arch User Repository (AUR) |

Official packages are installed using:

```bash
pacman -S --needed
```

AUR packages are installed using:

```bash
paru
```

or

```bash
yay
```

when available.

---

## Package Groups

### Desktop Environment

Core desktop components and Wayland integration.

Includes:

* Hyprland ecosystem
* Status bar
* Launchers
* Notifications
* Display management
* Session utilities

### Terminal Environment

Shells, prompts, terminal utilities, and command-line tooling.

Includes:

* Fish
* Zsh
* Starship
* Tmux
* Modern CLI utilities

### Development Tools

Tools commonly used for editing, navigation, and workflow enhancement.

Includes:

* Neovim
* Yazi
* FZF
* Fastfetch
* Btop

### Media & Utilities

Desktop applications and supporting utilities.

Includes:

* Screenshot tools
* Clipboard utilities
* OCR tools
* Translation tools
* Audio utilities

### System Integration

Packages required for desktop functionality.

Includes:

* PipeWire
* NetworkManager
* Bluetooth stack
* XDG portals
* PolicyKit

### Fonts

Fonts used throughout the desktop environment.

Includes:

* Noto Fonts
* Nerd Fonts
* Font Awesome

---

## AUR Packages

Nuroneko also installs a small number of AUR packages for functionality not available in the official repositories.

Current AUR packages include:

* Hyprshade
* SwayOSD
* Rofimoji
* Pokemon Colorscripts
* Zen Browser

> [!NOTE]
> If neither `paru` nor `yay` is installed, AUR packages are skipped automatically.

---

## Customizing Packages

Package manifests can be modified before installation.

### Official Packages

```text
packages/arch-official.txt
```

### AUR Packages

```text
packages/arch-aur.txt
```

Rules:

* One package per line
* Empty lines are ignored
* Lines beginning with `#` are treated as comments

---

## Reinstalling Packages

After modifying a package manifest, run the installer again:

```bash
./install.sh
```

The installer only installs missing packages and does not reinstall packages that already exist on the system.
