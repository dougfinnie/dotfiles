# ~/.config

Add real configs from a machine with:

```bash
chezmoi add ~/.config/<app>
```

Files in this directory in the repo become `~/.config/<app>` on `chezmoi apply`.

- **nvim** — LazyVim starter with fzf-lua picker; run `nvim` once (or headless `Lazy! sync`) to populate `~/.local/share/nvim`.
- **fzf** — shared defaults in `env.sh`; shell integration via `~/.bashrc.d/fzf.sh` and `~/.zshrc`.
- **tmux** — Catppuccin + TPM; `chezmoi apply` installs plugins into `~/.config/tmux/plugins`.
- **zsh** — configured in repo root `dot_zshrc`; OMZ/plugins/theme cloned on apply (see main README).
