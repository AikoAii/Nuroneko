# Nuroneko

**A modular, reproducible Linux desktop configuration.**

> Nuroneko v2 is under active development. The v1.1.1 release is the
> last stable v1 snapshot.

## Goals

- Modular dotfiles organized by application.
- Native Lua configuration for Hyprland.
- Portable configuration without machine-specific paths.
- Reusable user scripts separated from installer tooling.
- Explicit package and init-system handling.
- Safe installation with backups and validation.
- Clear documentation and predictable versioning.

## Repository layout

| Path | Purpose |
|---|---|
| `dotfiles/` | GNU Stow packages |
| `bin/` | User-facing executables |
| `scripts/` | Development tools and shared helpers |
| `installer/` | Installation and deployment |
| `packages/` | Distribution-specific package manifests |
| `assets/` | Wallpapers, icons, fonts, cursors, and themes |
| `docs/` | Architecture and documentation |

## Dotfile deployment

Dotfile packages are designed around GNU Stow.

For example, the `hypr` package contains:

`dotfiles/hypr/.config/hypr/`

It maps to:

`~/.config/hypr/`

when stowed with the home directory as the target.

## Development status

- [ ] Define supported distributions and init systems.
- [ ] Implement native Lua Hyprland configuration.
- [ ] Add and validate dotfile packages.
- [ ] Implement installer and rollback.
- [ ] Add package manifests and dependency checks.
- [ ] Complete clean-install testing.

## License

See [LICENSE](LICENSE).
