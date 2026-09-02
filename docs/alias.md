# Alias Guide

Nuroneko includes a curated collection of aliases designed to simplify common terminal workflows.

These aliases focus on navigation, development, system management, package management, and Git operations.

---

## Navigation

Common shortcuts for moving around the filesystem.

Examples:

```bash
c           # cd
..          # Parent directory
...         # Two levels up
....        # Three levels up
h           # Home directory (~)
prev        # Previous directory
```

---

## File Management

Aliases that improve file browsing and manipulation.

Examples:

```bash
ls          # eza --icons
l           # Detailed listing with git
la          # Show hidden files
ll          # Long listing with git & icons
lt          # Tree view (level 2)
b           # Bat (file viewer)
z           # Zoxide (smart directory jump)
mk          # mkdir -pv
drag        # Ripdrag (drag & drop)
yy          # Open Yazi file manager
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
rg          # Ripgrep (smart-case search)
rgi         # Ripgrep case-insensitive
fd          # Find files (hidden & follow)
fda         # FD absolute path
ff          # Fuzzy search (fd | fzf)
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
n           # Neovim
m           # Micro editor
py          # Python
gpp         # G++ compiler
fast        # Fastfetch
serve       # Local Python web server
```

---

## System & Network

Common System & Network administration shortcuts.

Examples:

```bash
df          # Disk free (-h)
du          # Dust disk usage (-d 2)
dua         # Dust full usage
top         # Btop system monitor
free        # Free memory (-h)
ip          # Colored IP output
ports       # Listening ports (ss)
ps          # Procs process viewer
psg         # Procs watch live
ssh         # Kitty kitten SSH
pi          # Gping network test
curl        # Curlie HTTP client
```

---

## Package Management

Package management shortcuts for Arch Linux.

Examples:

```bash
:v          # System upgrade (sudo pacman -Syu)
p           # Pacman
qi          # Package info
qs          # Search installed packages
rm-pkg      # Remove package & orphans (Rns)
cleanpkg    # Clean cache (-Sc)
```

---

## Git

Frequently used Git commands with shorter aliases.

Examples:

```bash
g           # git
gs          # git status
ga          # git add .
gA          # git add -A
gc          # git commit
gcm         # git commit -m
gp          # git push
gl          # git pull
gd          # git diff
gb          # git branch
gco         # git checkout
gcl         # git clone
glog        # Git log graph
gundo       # Soft reset last commit (HEAD~1)
gclean      # Clean untracked files (-fd)
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
sl          # ls
cim         # nvim
chmox       # chmod
grpe        # grep
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
