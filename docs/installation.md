# Installation Guide

## System Compatibility Matrix

| Environment | Supported Status | Notes |
| :--- | :--- | :--- |
| **Arch Linux + systemd** | ✅ Supported | Default Arch configuration |
| **Arch Linux + OpenRC** | 🟡 Experimental | Community init setup |
| **Artix Linux + dinit** | ✅ Supported | Primary development target |
| **Artix Linux + OpenRC** | ✅ Supported | Tested Artix init |
| **Artix Linux + systemd** | ✅ Supported | Artix systemd suite |

> [!NOTE]
> `pacman` is required for automatic package deployment. Other distributions (Debian/Fedora) are not yet supported.

---

## Requirements

Before installing Nuroneko, ensure your system meets the following requirements:

* Arch Linux or Artix Linux
* Required CLI tools: `bash`, `git`, `grep`, `sed`, `find`, `ln`, `mkdir`, `chmod`, `mv`, `readlink`
* Package Manager: `pacman`
* Privilege Escalation: `sudo` or `doas`

*Optional Tools:*
* AUR helper: `yay` or `paru`
* TUI Menu engine: `whiptail` or `dialog` (Falls back cleanly to text-based CLI menu if absent)

---

## Clone the Repository

```bash
git clone https://github.com/AikoAii/Nuroneko.git
cd Nuroneko
```

---

## Usage & Installation Commands

### Interactive Wizard (Recommended)

```bash
./install.sh
```

Launches the interactive setup wizard allowing you to choose between:
* **Full Setup:** Packages + Configs + SDDM Theme + Services
* **Configs Only:** Only deploy dotfiles (`~/.config` & `~/.local`)
* **Custom Selection:** Select granular components via checklist

### Dry-Run Mode (Simulation)

```bash
./install.sh --dry-run
```

Simulates the entire installation process in read-only mode without modifying files, installing packages, or changing system services.

### Development Mode (Symlinks)

```bash
./install.sh --symlink
```

Creates symbolic links instead of copying configuration files.

### System Diagnostics (Doctor)

```bash
./install.sh doctor
```

Runs the standalone diagnostic tool to verify environment status, required/optional dependencies, active init system, service statuses, and broken symlinks.

---

## Backups

Before deploying any configuration, Nuroneko creates a timestamped backup manifest:

```text
~/.local/share/nuroneko/backups/YYYY-MM-DD_HH-MM-SS/
```

---

## Uninstallation & Troubleshooting

If you encounter issues during installation or wish to troubleshoot:

* Run `./install.sh doctor` to produce diagnostic logs for GitHub issues.
* Review [Troubleshooting Guide](./troubleshooting.md)
