# Troubleshooting

This document covers common issues that may occur during installation or daily use of Nuroneko.

---

# Installation

## Unsupported Distribution

```text
[ERROR] Unsupported distribution
```

Nuroneko officially supports:

* Arch Linux
* Artix Linux

Other distributions are not tested and may not work correctly.

---

## pacman Not Found

```text
[ERROR] pacman not found
```

Ensure you are using an Arch-based system and that `pacman` is installed and available in `PATH`.

---

## Neither sudo nor doas Found

```text
[ERROR] Neither sudo nor doas found
```

Install either:

```bash id="7d3vf7"
pacman -S sudo
```

or configure `doas`.

---

## Installer Executed as Root

```text
[ERROR] Do not run this installer as root
```

Run the installer as a normal user:

```bash id="e2cprv"
./install.sh
```

Do not use:

```bash id="ng8ikc"
sudo ./install.sh
```

---

## No AUR Helper Found

```text
[WARN] No AUR helper found
```

AUR packages are optional.

Install one of:

```bash id="mh8s07"
paru
```

or

```bash id="xl93vh"
yay
```

and re-run the installer.

---

# Hyprland

## Hyprland Does Not Start

Verify installation:

```bash id="53grhc"
pacman -Q hyprland
```

Check logs:

```bash id="zzg8z9"
journalctl -b
```

Common causes:

* Missing GPU drivers
* Broken configuration
* Incorrect environment variables

---

## Black Screen After Login

Check:

```bash id="q6lyad"
~/.config/hypr/
```

for syntax errors.

You can temporarily move the configuration:

```bash id="2u06zs"
mv ~/.config/hypr ~/.config/hypr.bak
```

and test with a fresh configuration.

---

## Waybar Not Appearing

Verify:

```bash id="35crhj"
waybar
```

from a terminal.

Common causes:

* Invalid JSON configuration
* Missing fonts
* Missing modules

Check logs:

```bash id="ksdnjk"
waybar
```

and review any errors.

---

## Wallpapers Not Loading

Verify:

```bash id="z7et3k"
hyprpaper
```

is running.

Check:

```bash id="vcd4su"
~/.local/share/wallpapers/
```

for deployed wallpapers.

---

# Audio

## No Sound

Verify PipeWire services:

```bash id="h8kt84"
systemctl --user status pipewire
systemctl --user status wireplumber
```

Test output devices:

```bash id="l5s6nk"
pavucontrol
```

---

## Volume Keys Not Working

Check:

```bash id="m8ccvw"
pamixer --get-volume
```

If the command fails, reinstall:

```bash id="a2c9v0"
pacman -S pamixer
```

---

# Network

## Wi-Fi Not Working

Verify:

```bash id="5j6f4k"
systemctl status NetworkManager
```

Enable it:

```bash id="qv0x1e"
sudo systemctl enable --now NetworkManager
```

---

## DNS Issues

Test connectivity:

```bash id="4b0h9u"
ping 1.1.1.1
```

If IP connectivity works but domains fail:

```bash id="6h35mr"
ping google.com
```

review DNS configuration.

---

# Bluetooth

## Bluetooth Not Working

Verify:

```bash id="pw1j0g"
systemctl status bluetooth
```

Enable it:

```bash id="fdixz2"
sudo systemctl enable --now bluetooth
```

---

## Device Pairing Fails

Remove existing pairing:

```bash id="pmkjzo"
bluetoothctl
```

Inside bluetoothctl:

```text
remove XX:XX:XX:XX:XX:XX
scan on
pair XX:XX:XX:XX:XX:XX
```

---

# Shell

## Fish Plugins Missing

Refresh plugins:

```fish
fisher update
```

If Fisher is missing:

```fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher install jorgebucaran/fisher
```

---

## Aliases Not Available

Reload Fish:

```fish
source ~/.config/fish/config.fish
```

or restart the shell.

---

## Functions Not Found

Verify:

```fish
functions mkcd
```

Check:

```text
~/.config/fish/functions/
```

for missing files.

---

# Tmux

## Plugins Not Loading

Install TPM plugins:

```text
Ctrl-Space + I
```

Reload:

```text
Ctrl-Space + r
```

---

## TPM Missing

Install TPM manually:

```bash id="4xkgbh"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

---

# Symlink Mode

## Broken Symlinks

Check:

```bash id="41s1k6"
find ~/.config -xtype l
```

If the repository was moved:

```bash id="s7h14r"
./install.sh --symlink
```

to regenerate links.

---

# Services

## Services Not Enabled

For systemd:

```bash id="8n0w8j"
sudo systemctl enable --now NetworkManager bluetooth
```

For OpenRC:

```bash id="t6h5na"
sudo rc-update add NetworkManager default
sudo rc-update add bluetoothd default
```

For runit:

```bash id="3o8vyu"
sudo ln -sf /etc/sv/NetworkManager /var/service/
```

For dinit:

```bash id="w7jnhn"
sudo dinitctl enable NetworkManager
```

---

# Validation

## Validation Reports Warnings

Warnings are usually non-fatal.

Common reasons:

* Optional package missing
* AUR helper unavailable
* Service skipped
* User customization detected

Review the warning message before taking action.

---

# Getting Help

Before reporting an issue, include:

```bash id="u7sy5v"
fastfetch
```

```bash id="2t9f2v"
hyprctl version
```

```bash id="2n45z7"
pacman -Q hyprland
```

and any relevant log output.

This information makes troubleshooting significantly easier.
