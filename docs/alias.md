# Alias Guide

Nuroneko includes a curated collection of aliases designed to simplify common terminal workflows.

These aliases focus on navigation, development, system management, package management, and Git operations.

---

## Navigation

Common shortcuts for moving around the filesystem.

Examples:

```bash
..      # Parent directory
...     # Two levels up
....    # Three levels up
h       # Home directory
prev    # Previous directory
```

---

## File Management

Aliases that improve file browsing and manipulation.

Examples:

```bash
ls      # Enhanced file listing
l       # Detailed listing
la      # Show hidden files
lt      # Tree view
yy      # Open Yazi
```

These aliases use modern CLI tools such as:

* Eza
* Bat
* Yazi

---

## Search

Fast file and content discovery.

Examples:

```bash
rg      # Search text
fd      # Find files
ff      # Fuzzy search
```

Powered by:

* Ripgrep
* FD
* FZF

---

## Development

Convenience aliases for development workflows.

Examples:

```bash
n       # Neovim
fast    # Fastfetch
serve   # Local web server
```

---

## System

Common system administration shortcuts.

Examples:

```bash
top     # System monitor
ports   # Listening ports
psg     # Process viewer
jctl    # System logs
```

---

## Package Management

Package management shortcuts for Arch Linux.

Examples:

```bash
update      # System upgrade
searchpkg   # Search packages
remove      # Remove package
cleanpkg    # Clean cache
```

---

## Git

Frequently used Git commands with shorter aliases.

Examples:

```bash
gs      # git status
ga      # git add
gcm     # git commit -m
gp      # git push
glog    # git log graph
```

---

## Docker

Short aliases for container management.

Examples:

```bash
d       # docker
dc      # docker compose
dps     # list containers
```

---

## Typo Protection

Nuroneko includes several typo guards that redirect common mistakes to the intended command.

Examples:

```bash
sl      # ls
cim     # nvim
chmox   # chmod
```

---

## Viewing All Aliases

To see every available alias:

```bash
alias
```

Or inspect the source file directly:

```bash
n ~/.config/fish/conf.d/alias.fish
```
