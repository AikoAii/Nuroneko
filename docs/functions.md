# Functions Guide

Nuroneko includes a collection of helper functions designed to simplify common development, system administration, and daily terminal workflows.

These functions extend the shell beyond simple aliases by providing reusable utilities with additional logic and automation.

---

## Python Environment

Utilities for managing Python virtual environments.

| Function | Description                                   |
| -------- | --------------------------------------------- |
| `mkvenv` | Create and activate a new virtual environment |
| `avenv`  | Activate an existing virtual environment      |

Example:

```bash
mkvenv
avenv
```

---

## File Management

Utilities for creating, managing, and navigating files.

| Function            | Description                                                |
| ------------------- | ---------------------------------------------------------- |
| `mkcd <dir>`        | Create a directory and enter it                            |
| `take <dir>`        | Alternative name for `mkcd`                                |
| `mkfile <file>`     | Create a file and open it in Neovim                        |
| `backup <path>`     | Create a timestamped backup                                |
| `extract <archive>` | Extract supported archives                                 |
| `y`                 | Launch Yazi while preserving the current working directory |

Examples:

```bash
mkcd project
mkfile main.cpp
backup config.fish
extract archive.zip
```

### Supported Archive Formats

* ZIP
* RAR
* TAR
* TAR.GZ
* TAR.BZ2
* TAR.XZ

---

## Git Workflow

Utilities for common Git operations.

| Function | Description                                         |
| -------- | --------------------------------------------------- |
| `gitnew` | Initialize a repository and create the first commit |

Example:

```bash
gitnew
```

---

## Package Management

Utilities for maintaining an Arch-based system.

| Function        | Description                             |
| --------------- | --------------------------------------- |
| `install <pkg>` | Install a package                       |
| `updateall`     | Upgrade installed packages              |
| `cleanup`       | Remove orphan packages and clean caches |

Examples:

```bash
install neovim
updateall
cleanup
```

---

## Network Utilities

Functions related to connectivity and information retrieval.

| Function         | Description                  |
| ---------------- | ---------------------------- |
| `netcheck`       | Verify internet connectivity |
| `weather [city]` | Display weather information  |

Examples:

```bash
netcheck
weather
weather tokyo
```

---

## Development Utilities

Small helpers for local development workflows.

| Function        | Description                              |
| --------------- | ---------------------------------------- |
| `serve [port]`  | Start a local HTTP server                |
| `cheat <topic>` | Display command references from cheat.sh |

Examples:

```bash
serve
serve 8080

cheat git
cheat tmux
```

---

## Notes

Quick note-taking utilities.

| Function      | Description               |
| ------------- | ------------------------- |
| `note`        | Open the notes file       |
| `note <text>` | Append a timestamped note |

Examples:

```bash
note

note Remember to update dotfiles
```

---

## Utilities

Miscellaneous helper functions.

| Function          | Description                       |
| ----------------- | --------------------------------- |
| `timer <seconds>` | Start a countdown timer           |
| `wget`            | XDG-compliant wrapper around Wget |

Examples:

```bash
timer 60
timer 1800

wget https://example.com/file.zip
```

---

## Viewing Function Definitions

To inspect the implementation of a function:

```bash
functions mkcd
```

Or browse the source files directly:

```bash
n ~/.config/fish/functions/
```
