# fzf key bindings and fuzzy completion (CTRL-T / CTRL-R / ALT-C, ** completion).
# https://github.com/junegunn/fzf#setting-up-shell-integration

if command -v fzf >/dev/null 2>&1; then
  # shellcheck source=/dev/null
  [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/env.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/env.sh"
  eval "$(fzf --bash)"
fi
