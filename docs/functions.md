# Functions Guide

A collection of helper functions included with Nuroneko to streamline development, system maintenance, and daily terminal workflows.

---

## Python

| Function | Description                                                |
| -------- | ---------------------------------------------------------- |
| `mkvenv` | Create and activate a Python virtual environment (`.venv`) |
| `avenv`  | Activate an existing Python virtual environment            |


---

## Files

| Function            | Description                                    |
| ------------------- | ---------------------------------------------- |
| `mkcd <dir>`        | Create a directory and enter it                |
| `take <dir>`        | Alternative name for `mkcd`                    |
| `mkfile <file>`     | Create a file and open it in Neovim            |
| `backup <path>`     | Create a timestamped backup copy               |
| `extract <archive>` | Extract supported archive formats              |
| `y`                 | Launch Yazi and preserve the working directory |

### Supported Archives

.zip
.rar
.tar.gz
.tgz
.tar.bz2
.tar.xz

---

## Git

| Function | Description                                             |
| -------- | ------------------------------------------------------- |
| `gitnew` | Initialize a Git repository and create the first commit |


---

## Package Management

| Function        | Description                                    |
| --------------- | ---------------------------------------------- |
| `install <pkg>` | Install a package using Pacman                 |
| `updateall`     | Upgrade all installed packages                 |
| `cleanup`       | Clean package cache and remove orphan packages |

---

## Network

| Function         | Description                 |
| ---------------- | --------------------------- |
| `netcheck`       | Check internet connectivity |
| `weather [city]` | Display weather information |
 

---

## Development

| Function        | Description                               |
| --------------- | ----------------------------------------- |
| `serve [port]`  | Start a local HTTP server                 |
| `cheat <topic>` | Display command cheatsheets from cheat.sh |

    
---

## Notes

| Function      | Description                                 |
| ------------- | ------------------------------------------- |
| `note`        | Open the notes file                         |
| `note <text>` | Append a timestamped note and open the file |

---

## Utilities

| Function          | Description                                     |
| ----------------- | ----------------------------------------------- |
| `timer <seconds>` | Start a countdown timer and send a notification |
| `wget`            | XDG-compliant wrapper for Wget                  |

### Examples

     
timer 60

timer 1800

wget https://example.com/file.zip
    

---

