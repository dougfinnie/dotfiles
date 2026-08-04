#!/usr/bin/env bash
# Verify toolchain for this dotfiles repo (Linux / WSL). Does not elevate privileges.
#
# Remotes: Forgejo is canonical for pushes; GitHub may mirror the same tree.
# For `chezmoi init`, any HTTPS/SSH clone URL works — see README "Where this repo lives".
set -euo pipefail

MIN_NVIM='0.11'
# Default clone URL for --init (Forgejo / origin). Override e.g. with GitHub mirror if Forgejo is unreachable.
DOTFILES_REPO_DEFAULT='ssh://git@mintie.grouse-matrix.ts.net:222/doug/dotfiles.git'
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

check_tmux() {
  have_cmd tmux || die "tmux not found. Install tmux (e.g. Fedora: sudo dnf install tmux)."
  echo "tmux $(tmux -V | awk '{print $2}') — ok"
}

check_fzf() {
  have_cmd fzf || die "fzf not found. Install fzf (e.g. Fedora: sudo dnf install fzf)."
  echo "fzf $(fzf --version | head -n1) — ok"
}

check_zsh() {
  have_cmd zsh || die "zsh not found. Install zsh (e.g. Fedora: sudo dnf install zsh)."
  echo "zsh $(zsh --version | head -n1) — ok"
}

check_starship() {
  if have_cmd starship; then
    echo "starship $(starship --version | head -n1) — ok"
    return 0
  fi
  echo "starship — missing (run chezmoi apply to install into ~/.local/bin; see https://starship.rs/)"
  return 0
}

check_zoxide() {
  have_cmd zoxide || die "zoxide not found. Install zoxide (e.g. Fedora: sudo dnf install zoxide)."
  echo "zoxide $(zoxide --version | head -n1) — ok"
}

warn_optional_zsh() {
  # Nice-to-haves: shell still starts without them (gated in ~/.config/zsh).
  local pkg
  for pkg in bat eza fd; do
    if have_cmd "$pkg"; then
      echo "$pkg — ok (optional)"
    else
      echo "$pkg — missing (optional; Fedora: sudo dnf install bat eza fd-find)"
    fi
  done
  if [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    echo "zsh-autosuggestions — ok (optional package)"
  else
    echo "zsh-autosuggestions — missing (optional; Fedora: sudo dnf install zsh-autosuggestions)"
  fi
  if [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    echo "zsh-syntax-highlighting — ok (optional package)"
  else
    echo "zsh-syntax-highlighting — missing (optional; Fedora: sudo dnf install zsh-syntax-highlighting)"
  fi
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
  echo "  --init   run: chezmoi init --apply <url>"
  echo "  If DOTFILES_REPO is unset, uses Forgejo (canonical): $DOTFILES_REPO_DEFAULT"
  echo "  Override: DOTFILES_REPO=<url> $0 --init   (e.g. GitHub mirror URL)"
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
  check_tmux
  check_fzf
  check_zsh
  check_zoxide
  check_starship
  warn_optional_zsh
  check_nvim
  if ! check_chezmoi; then
    die "Install chezmoi, ensure it is on PATH, then re-run."
  fi

  if [[ "$do_init" -eq 1 ]]; then
    local url="$DOTFILES_REPO_DEFAULT"
    if [[ -n "${DOTFILES_REPO:-}" ]]; then
      url="$DOTFILES_REPO"
    else
      echo "DOTFILES_REPO unset — using default (Forgejo). Set DOTFILES_REPO to override (e.g. GitHub mirror)."
    fi
    echo "Running: chezmoi init --apply $url"
    chezmoi init --apply "$url"
    echo "Done. Review changes with: chezmoi diff"
    exit 0
  fi

  echo "All checks passed."
  echo "Next: add this repo as chezmoi source, or run: $0 --init (optional: DOTFILES_REPO=<url>)"
}

main "$@"
