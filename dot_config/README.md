# ~/.config

Add real configs from a machine with:

```bash
chezmoi add ~/.config/<app>
```

Files in this directory in the repo become `~/.config/<app>` on `chezmoi apply`.

- **nvim** — LazyVim starter; run `nvim` once (or headless `Lazy! sync`) to populate `~/.local/share/nvim`.
- **tmux** — Catppuccin + TPM; `chezmoi apply` installs plugins into `~/.config/tmux/plugins`.
