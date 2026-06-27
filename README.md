# Nuroneko

Nuroneko is a modular Hyprland environment for people who want a complete Arch Linux or Artix Linux desktop without manually assembling and maintaining dozens of separate configurations.

It provides a cohesive desktop workflow around Hyprland, including application launching, notifications, clipboard management, OCR utilities, screenshots, scratchpads, power management, shell tooling, and desktop integration. The project combines configuration, tooling, deployment, and workflow into a single maintainable environment instead of a collection of unrelated dotfiles.

The environment is designed around modern Wayland workflows, keyboard-driven interaction, and long-term maintainability. Configuration deployment, service integration, backups, and validation are handled automatically through the provided installer.

> [!IMPORTANT]
> Arch Linux and Artix Linux are currently the primary supported platforms.
> Future support for additional distributions may be explored as the project continues to evolve.

<p align="center">
  <img src=".meta/assets/logo.png" width="70%" alt="Nuroneko">
</p>

<p align="center">
  <a href="https://github.com/AikoAii/nuroneko/commits">
    <img src="https://img.shields.io/github/last-commit/AikoAii/nuroneko?style=for-the-badge&logo=git&label=Last%20Commit" alt="Last Commit" />
  </a>

  <a href="https://github.com/AikoAii/nuroneko/stargazers">
    <img src="https://img.shields.io/github/stars/AikoAii/nuroneko?style=for-the-badge&logo=github" alt="GitHub Stars" />
  </a>

  <!-- <a href="./docs">
    <img src="https://img.shields.io/badge/Documentation-Available-blue?style=for-the-badge&logo=gitbook" alt="Documentation" />
  </a> -->

  <a href="./LICENSE">
    <img src="https://img.shields.io/github/license/AikoAii/nuroneko?style=for-the-badge" alt="License" />
  </a>
</p>

<p align="center">
  <a href="#why-nuroneko">Why Nuroneko</a> •
  <a href="#what-it-includes">What It Includes?</a> •
  <a href="#supported-systemsYou Get</a> •
  <a href="#preview">Preview</a> •
  <a href="#installation">Installation</a> •
  <a href="#documentation">Documentation</a>
</p>

---

## Why Nuroneko

Many Hyprland setups focus primarily on appearance.

While visually impressive, they often require users to manually maintain independent configurations for launchers, notifications, screenshots, clipboard utilities, shell environments, status bars, and supporting scripts.

Over time, this can result in fragmented workflows, duplicated configuration, and increasing maintenance overhead.

Nuroneko approaches the desktop differently.

Rather than treating each component as a separate system, it provides a curated environment where common workflows are already integrated and designed to work together consistently.

The goal is not only to provide a visually cohesive desktop, but also to provide a desktop that remains easy to understand, extend, and maintain over time.

---

## What It Includes

Nuroneko provides a complete workflow around Hyprland, including:

* Application launching and desktop actions
* Clipboard history and clipboard utilities
* OCR and screenshot workflows
* Notification center and on-screen displays
* Scratchpad workflows
* Power profile management
* Wallpaper and appearance integration
* Terminal and shell tooling
* Development-oriented command-line utilities
* Safe configuration deployment and backup management

The project also includes an installation framework capable of:

* Detecting supported distributions
* Detecting supported init systems
* Installing required packages
* Creating configuration backups
* Deploying configurations safely
* Applying service configuration
* Validating installation results

---

## Supported Systems

Nuroneko currently supports:

| Distribution | Init Systems         |
| ------------ | -------------------- |
| Arch Linux   | systemd              |
| Artix Linux  | OpenRC, runit, dinit |

Init-specific service configuration is handled automatically during installation when supported.

---

## Scope

Nuroneko is an environment and workflow layer built around Hyprland.

It provides desktop integration, workflow tooling, shell configuration, utility integration, deployment tooling, and desktop customization.

Nuroneko does not replace the responsibilities of the Linux distribution itself, nor does it attempt to replace dedicated applications such as web browsers, development environments, office software, or media applications.

Users remain free to choose their preferred applications while benefiting from a consistent underlying desktop workflow.

---

## Preview

<table align="center">
  <tr>
    <td colspan="3">
      <a href="https://youtu.be/w_LmZ3DnkMw?si=jRVfj1dQAXsSO_lg">
        <img src=".meta/assets/video-preview.png" width="100%" alt="Nuroneko Showcase">
      </a>
    </td>
  </tr>

  <tr>
    <td>
      <img src=".meta/assets/rofi.png" alt="Launcher">
    </td>
    <td>
      <img src=".meta/assets/wallpaper.png" alt="Wallpaper">
    </td>
    <td>
      <img src=".meta/assets/keybinds.png" alt="Keybindings">
    </td>
  </tr>
</table>

---

## Installation

Clone the repository:

```bash
git clone https://github.com/AikoAii/Nuroneko.git ~/.config/Nuroneko
cd ~/.config/Nuroneko
```

Standard installation:

```bash
./install.sh
```

Development installation:

```bash
./install.sh --symlink
```

> [!NOTE]
> Existing configurations are automatically backed up before deployment.
>
> Backup archives are stored in:
>
> ```text
> ~/.local/share/Nuroneko/backups/
> ```

---

## Documentation

Additional documentation is available for:

- [Installation Guide](./docs/installation.md)
- [Package Reference](./docs/packages.md)
- [Shell Aliases](./docs/alias.md)
- [Shell Functions](./docs/functions.md)
- [Troubleshooting](./docs/troubleshooting.md)

Quick keybinding reference can be opened from within the desktop environment:

```text
SUPER + /
```

---

## Contributing

Bug reports, documentation improvements, workflow suggestions, and pull requests are welcome.

When contributing, please ensure that changes remain consistent with the project's goals of maintainability, modularity, and cross-init compatibility.

---

## Credits

Nuroneko builds upon the work of many open-source projects and communities that make modern Linux desktops possible.

<!--Special thanks to the maintainers, contributors, and users of the software that forms the foundation of this project.-->

---


## Support Me

<p align="left">
  <a href="https://trakteer.id/aikoaii" target="_blank">
    <img src="https://cdn.trakteer.id/images/embed/trbtn-red-1.png" height="40"/>
  </a>
</p>

---

## License

MIT License. See `LICENSE` for details.
