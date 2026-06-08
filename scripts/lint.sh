#!/usr/bin/env bash
# scripts/lint.sh — Pre-release validation script
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

errors=0
warnings=0

info()    { printf "%b[INFO]%b    %s\n" "\033[0;34m" "$NC" "$*"; }
ok()      { printf "%b[SUCCESS]%b %s\n" "$GREEN" "$NC" "$*"; }
fail()    { printf "%b[ERROR]%b   %s\n" "$RED" "$NC" "$*"; errors=$((errors + 1)); }
warning() { printf "%b[WARN]%b    %s\n" "$YELLOW" "$NC" "$*"; warnings=$((warnings + 1)); }

echo ""
echo "=========================================="
echo "  Nuroneko Pre-Release Lint"
echo "=========================================="
echo ""

# --- Bash Syntax Validation ---
info "Running bash syntax checks..."

while IFS= read -r -d '' script; do
  if bash -n "$script" 2>/dev/null; then
    ok "Syntax OK: $(basename "$script")"
  else
    fail "Syntax ERROR: $script"
  fi
done < <(find "$REPO_DIR" -name "*.sh" -type f \
  -not -path "*/tmux/plugins/*" \
  -not -path "*/.gemini/*" \
  -print0)

echo ""

# --- ShellCheck ---
if command -v shellcheck >/dev/null 2>&1; then
  info "Running ShellCheck..."

  while IFS= read -r -d '' script; do
    if shellcheck -x "$script" >/dev/null 2>&1; then
      ok "ShellCheck OK: $(basename "$script")"
    else
      warning "ShellCheck issues: $(basename "$script")"
      shellcheck -x "$script" 2>&1 | head -5
    fi
  done < <(find "$REPO_DIR" -name "*.sh" -type f \
    -not -path "*/tmux/plugins/*" \
    -not -path "*/.gemini/*" \
    -print0)
else
  warning "shellcheck not installed (install with: pacman -S shellcheck)"
fi

echo ""

# --- Security Checks ---
info "Running security checks..."

if grep -rqiE "token|apikey|api_key|secret|password|passwd|bearer" \
  --include="*.sh" --include="*.fish" --include="*.conf" \
  --exclude="lint.sh" \
  "$REPO_DIR" 2>/dev/null; then
  warning "Potential secrets detected (review manually)"
else
  ok "No secrets detected"
fi

if grep -rq "chikochi\|annur\|aiko" "$REPO_DIR" \
  --include="*.sh" --include="*.fish" --include="*.conf" --include="*.md" \
  --exclude="lint.sh" \
  2>/dev/null; then
  fail "Personal identifiers found in repository"
else
  ok "No personal identifiers"
fi

if grep -rqE "@gmail\.com|@outlook\.com|@yahoo\.com" "$REPO_DIR" \
  --include="*.sh" --include="*.fish" --include="*.conf" --include="*.md" \
  --exclude="lint.sh" \
  2>/dev/null; then
  fail "Personal email addresses found"
else
  ok "No personal emails"
fi

echo ""

# --- Language Policy ---
info "Checking for non-English comments..."

if grep -rqw -iE "enak|kunci|biar|pake|hapus|nyala|standar|Putih|Biru|Hitam|terlalu|Kolom|Garis" \
  --include="*.sh" --include="*.fish" --include="*.conf" \
  --exclude="lint.sh" \
  "$REPO_DIR" 2>/dev/null; then
  warning "Indonesian text detected in repository files"
else
  ok "All comments in English"
fi

echo ""

# --- Structure Checks ---
info "Checking repository structure..."

[[ -f "$REPO_DIR/README.md" ]] && ok "README.md exists" || fail "README.md missing"
[[ -d "$REPO_DIR/docs" ]] && ok "docs/ directory exists" || fail "docs/ directory missing"
[[ -f "$REPO_DIR/install.sh" ]] && ok "install.sh exists" || fail "install.sh missing"

# Check for bundled plugin repos that should use package managers
if [[ -d "$REPO_DIR/configs/.config/tmux/plugins" ]]; then
  warning "Bundled tmux plugins found (should use TPM)"
else
  ok "No bundled tmux plugins"
fi

echo ""

# --- Summary ---
echo "=========================================="
printf "  Errors:   %s\n" "$errors"
printf "  Warnings: %s\n" "$warnings"
echo "=========================================="

if [[ $errors -gt 0 ]]; then
  echo ""
  fail "Pre-release checks FAILED"
  exit 1
else
  echo ""
  ok "Pre-release checks PASSED"
  exit 0
fi
