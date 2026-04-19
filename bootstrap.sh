#!/usr/bin/env bash
# Verify toolchain for this dotfiles repo (Linux / WSL). Does not elevate privileges.
set -euo pipefail

MIN_NVIM='0.11'
DOTFILES_REPO="${DOTFILES_REPO:-}"

die() {
  echo "bootstrap: $*" >&2
  exit 1
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

ver_ge() {
  # true if $1 >= $2 (semantic-ish versions: 0.11, 0.11.6, 0.12.0)
  local got="$1" min="$2"
  [[ "$(printf '%s\n' "$min" "$got" | sort -V | head -n1)" == "$min" ]]
}

check_nvim() {
  have_cmd nvim || die "Neovim not found. Install nvim (distro package is fine for Option A)."
  local got
  got=$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1)
  [[ -n "$got" ]] || die "Could not parse Neovim version."
  ver_ge "$got" "$MIN_NVIM" || die "Neovim $got is too old; need >= $MIN_NVIM (Option A)."
  echo "Neovim $got (>= $MIN_NVIM) — ok"
}

check_core() {
  have_cmd git || die "git not found."
  echo "git — ok"
  have_cmd make || die "make not found (needed for some Neovim plugin builds)."
  echo "make — ok"
}

check_chezmoi() {
  if have_cmd chezmoi; then
    echo "chezmoi $(chezmoi --version | head -n1) — ok"
    return 0
  fi
  echo "chezmoi not found. Install from https://chezmoi.io/install/"
  echo "  Example (user install): sh -c \"\$(curl -fsSL https://git.io/chezmoi)\" -- -b \"\$HOME/.local/bin\""
  echo "  Fedora: sudo dnf install chezmoi"
  return 1
}

usage() {
  echo "Usage: $0 [--init] [--help]"
  echo "  --init   run: chezmoi init --apply \"\$DOTFILES_REPO\" (set DOTFILES_REPO first)"
  echo "  Env:     DOTFILES_REPO=https://github.com/you/dotfiles.git"
}

main() {
  local do_init=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --init) do_init=1 ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown argument: $1" ;;
    esac
    shift
  done

  echo "=== dotfiles bootstrap (Option A: Neovim >= $MIN_NVIM) ==="
  check_core
  check_nvim
  if ! check_chezmoi; then
    die "Install chezmoi, ensure it is on PATH, then re-run."
  fi

  if [[ "$do_init" -eq 1 ]]; then
    [[ -n "$DOTFILES_REPO" ]] || die "Set DOTFILES_REPO to your git URL (see README)."
    echo "Running: chezmoi init --apply $DOTFILES_REPO"
    chezmoi init --apply "$DOTFILES_REPO"
    echo "Done. Review changes with: chezmoi diff"
    exit 0
  fi

  echo "All checks passed."
  echo "Next: add this repo as chezmoi source, or run: DOTFILES_REPO=<url> $0 --init"
}

main "$@"
