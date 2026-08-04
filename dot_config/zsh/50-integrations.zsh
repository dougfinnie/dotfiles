# fzf — shared env then shell integration (CTRL-T / CTRL-R / ALT-C).
if command -v fzf >/dev/null 2>&1; then
  [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/env.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/env.sh"
  source <(fzf --zsh)
fi

# Prompt (replaces Spaceship / OMZ themes).
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Plugins: prefer Fedora packages under /usr/share. Highlighting must stay last among plugins.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1

_zsh_autosuggestions=/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r $_zsh_autosuggestions ]] && source $_zsh_autosuggestions
unset _zsh_autosuggestions

_zsh_syntax_hl=/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -r $_zsh_syntax_hl ]] && source $_zsh_syntax_hl
unset _zsh_syntax_hl

# zoxide last — its doctor expects init near the end of the rc chain.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
