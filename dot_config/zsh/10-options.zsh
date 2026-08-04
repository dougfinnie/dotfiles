setopt autocd extendedglob nomatch complete_in_word auto_menu
unsetopt beep notify

# Esc Esc → prepend sudo (OMZ sudo plugin equivalent).
sudo-command-line() {
  [[ -z $BUFFER ]] && zle up-history
  if [[ $BUFFER != sudo\ * ]]; then
    BUFFER="sudo $BUFFER"
    CURSOR=$((CURSOR + 5))
  fi
}
zle -N sudo-command-line
bindkey '\e\e' sudo-command-line

# Fedora PackageKit “command not found” hints (also defines zsh handler).
[[ -r /etc/profile.d/PackageKit.sh ]] && source /etc/profile.d/PackageKit.sh
