#!/usr/bin/env bash
# scripts/utils/lib.sh — Shared helper library

# ==============================================================
# Colors
# ==============================================================

if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  NC='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  CYAN=''
  BOLD=''
  NC=''
fi

# ==============================================================
# Logging
# ==============================================================

info() {
  printf "%b[INFO]%b    %s\n" "$BLUE" "$NC" "$*"
}

ok() {
  printf "%b[SUCCESS]%b %s\n" "$GREEN" "$NC" "$*"
}


error() {
  printf "%b[ERROR]%b   %s\n" "$RED" "$NC" "$*" >&2
  exit 1
}

fatal() {
  printf "%b[FATAL]%b   %s\n" "$RED" "$NC" "$*" >&2
  exit 2
}

warn() {
  ((INSTALL_WARNINGS++)) || true
  printf "%b[WARN]%b    %s\n" "$YELLOW" "$NC" "$*" >&2
}

step() {
  printf "\n%b==> %s%b\n" "$BOLD$CYAN" "$*" "$NC"
}

# ==============================================================
# Dependency checks
# ==============================================================

require_function() {
  declare -F "$1" >/dev/null 2>&1 || {
    error "Missing required function: $1"
  }
}

require() {
  local cmd="$1"

  command -v "$cmd" >/dev/null 2>&1 ||
    error "Required command not found: ${cmd}"
}

require_any() {

  local found=1

  for cmd in "$@"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      found=0
      break
    fi
  done

  [[ $found -eq 0 ]] ||
    error "None of the required commands found: $*"
}

# ==============================================================
# Desktop notifications
# ==============================================================

notify() {

  local title="$1"
  local body="${2:-}"

  if command -v notify-send >/dev/null 2>&1; then

    notify-send "$title" "$body" \
      >/dev/null 2>&1 ||
      warn "Failed to send desktop notification"
  fi
}

# ==============================================================
# Dry Run Execution Helpers
# ==============================================================

DRY_RUN="${DRY_RUN:-false}"

dry_cmd() {
  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    printf "%b[DRY-RUN]%b  would execute: %s\n" "$CYAN" "$NC" "$*"
    return 0
  else
    "$@"
  fi
}

safe_symlink() {
    local src="$1"
    local dst="$2"

    [[ -e "$src" || -L "$src" ]] \
        || error "Symlink source does not exist: ${src}"

    # Prevent overwriting real files/directories
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        warn "Target exists and is not a symlink: ${dst}"
        return 1
    fi

    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        printf "%b[DRY-RUN]%b  would symlink: %s -> %s\n" "$CYAN" "$NC" "$dst" "$src"
        return 0
    fi

    ln -sfn "$src" "$dst" \
        || error "Failed to create symlink: ${dst}"

    return 0
}

ensure_dir() {
  local dir="$1"

  if [[ ! -d "$dir" ]]; then
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
      printf "%b[DRY-RUN]%b  would create directory: %s\n" "$CYAN" "$NC" "$dir"
      return 0
    fi

    mkdir -p "$dir" ||
      error "Failed to create directory: ${dir}"
  fi
}


