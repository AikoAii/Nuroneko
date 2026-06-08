# Troubleshooting

## Installer Errors

### `pacman not found`

```
[ERROR] pacman not found (Arch/Artix only)
```

Nuroneko only supports Arch Linux and Artix Linux. Other distributions (Fedora, Debian, Ubuntu, etc.) are not supported.

---

### `Unsupported distribution`

```
[ERROR] Unsupported distribution: Ubuntu 24.04 LTS (Only Arch and Artix are supported)
```

The installer reads `/etc/os-release` and only accepts `ID=arch` or `ID=artix`. If you are on a derivative (e.g., EndeavourOS, Manjaro), the ID may differ. You can try modifying `scripts/install/detect-distro.sh` to add your distro.

---

### `Neither sudo nor doas found`

```
[ERROR] Neither sudo nor doas found
```

Install `sudo` or `doas`:

```bash
# As root
pacman -S sudo
```

---

### `No AUR helper found`

```
[WARN] No AUR helper found (paru or yay). Skipping AUR packages.
```

This is a warning, not an error. AUR packages will be skipped. To install them:

```bash
# Install paru (recommended)
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

Then re-run the installer.

---

### `Do not run this installer as root`

```
[ERROR] Do not run this installer as root or with sudo
```

Run the installer as your normal user:

```bash
# Wrong
sudo ./install.sh

# Correct
./install.sh
```

The installer will use `sudo` internally only when needed (e.g., for pacman).

---

## Post-Installation Issues

### Tmux plugins not loading

If tmux starts without the Catppuccin theme or status modules:

1. Open tmux
2. Press `Ctrl-Space + I` (prefix + I) to install plugins via TPM
3. Press `Ctrl-Space + r` to reload the configuration

If TPM itself is missing:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

---

### Fish shell plugins not working

If Fisher plugins are not loaded:

```bash
# Install Fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher install jorgebucaran/fisher

# Install plugins from fish_plugins
fisher update
```

---

### Hyprland not starting

If Hyprland fails to start from tty1:

1. Check that `.bash_profile` is deployed to `~/`
2. Verify Hyprland is installed: `pacman -Q hyprland`
3. Check for GPU driver issues: `journalctl -b | grep -i gpu`

---

### Broken symlinks after moving the repository

If you used `--symlink` mode and then moved the repository directory, all symlinks will break. Fix by either:

- Moving the repository back to its original location
- Re-running the installer from the new location:

```bash
cd /new/location/nuroneko
./install.sh --symlink
```

---

### Services not enabled

If services (NetworkManager, bluetooth, sddm) are not running after installation:

```bash
# For systemd
sudo systemctl enable --now NetworkManager bluetooth sddm

# For OpenRC
sudo rc-update add NetworkManager default
sudo rc-update add bluetoothd default
sudo rc-update add sddm default

# For runit
sudo ln -sf /etc/sv/NetworkManager /var/service/
sudo ln -sf /etc/sv/bluetoothd /var/service/
sudo ln -sf /etc/sv/sddm /var/service/

# For dinit
sudo dinitctl enable NetworkManager
sudo dinitctl enable bluetoothd
sudo dinitctl enable sddm
```

---

## Validation

After installation, the installer automatically validates:

- Configuration files deployed correctly
- Assets (icons, wallpapers) in place
- Scripts in `~/.local/bin/` are executable
- No broken symlinks
- Services enabled

If validation reports warnings, review them — most are non-critical and indicate optional items that were skipped.
