# Chezmoi-managed edit (never drift from the source tree).
alias ed='chezmoi edit ~/.zshrc'
alias refresh='source ~/.zshrc'

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -l --group-directories-first --git'
  alias la='eza -la --group-directories-first --git'
fi
