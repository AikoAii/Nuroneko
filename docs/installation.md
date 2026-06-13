# Installation Guide

## Requirements

Before installing Nuroneko, ensure your system meets the following requirements:

* Arch Linux or Artix Linux
* `pacman`
* `git`
* `sudo` or `doas`
* Internet connection

> [!NOTE]
> Other Linux distributions are not officially supported at this time.

---

## Clone the Repository

```bash
git clone https://github.com/AikoAii/nuroneko.git
cd nuroneko
```

---

## Installation

### Standard Installation

```bash
./install.sh
```

Recommended for most users.

Configurations are copied to their target locations.

### Development Installation

```bash
./install.sh --symlink
```

Creates symbolic links instead of copying files.

Useful when actively modifying configurations, as changes are reflected immediately without reinstalling.

---

## What the Installer Does

The installer automatically:

1. Detects the distribution and init system
2. Installs required packages
3. Creates configuration backups
4. Deploys configurations
5. Configures supported services
6. Applies required permissions
7. Validates the installation

---

## Backups

Before deploying any configuration, Nuroneko creates a timestamped backup.

```text
~/.local/share/nuroneko/backups/
```

> [!IMPORTANT]
> Existing configurations are never overwritten without first being backed up.

---

## After Installation

After installation completes:

1. Log out and log back in
2. Restart Hyprland if necessary
3. Verify that all components start correctly

Optional:

* Run `fisher update` to refresh Fish plugins
* Run `prefix + I` in tmux to install TPM plugins

---

## Uninstallation

Nuroneko does not provide an automated uninstall script.

To restore your previous configuration:

1. Open the backup directory
2. Locate the desired backup snapshot
3. Review `MANIFEST.txt`
4. Restore the files you want to recover

---

## Troubleshooting

If you encounter issues during installation, see:

* [Troubleshooting Guide](./troubleshooting.md)
