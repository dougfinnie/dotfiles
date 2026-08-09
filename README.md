# Dotfiles (Linux / WSL)

Central configuration for machines you control. Layout follows **XDG**: everything lives under `~/.config` (and a few top-level dotfiles when you add them) so paths stay predictable across distros.

## Where this repo lives

| Role | Notes |
|------|--------|
| **Forgejo (canonical)** | Day-to-day `git push` / `pull` target. Use the **Clone** URL from your Forgejo project page (HTTPS or SSH). |
| **GitHub (optional mirror)** | [github.com/dougfinnie/dotfiles](https://github.com/dougfinnie/dotfiles) — same tree, for visibility or tooling; **do not push to both** unless you use a deliberate mirror workflow (push to Forgejo only and let mirroring update GitHub). |

For **chezmoi** and **`DOTFILES_REPO`**, any clone URL works as long as it points at this tree. **`bootstrap.sh --init`** defaults to the **Forgejo** remote; set **`DOTFILES_REPO`** to the **GitHub mirror** on a machine that cannot reach Forgejo. After a fast-forward mirror, the result is the same.

### Git workflow (on your machines)

- **Clone** from either host; content should match if mirroring is set up.
- **`origin`** should usually be your **Forgejo** URL so `git push` updates the canonical repo.
- If you only cloned from GitHub, add Forgejo and point `origin` at it, or push explicitly: `git push forgejo main` (whatever remote name you use).

## Principles

- **Neovim**: [LazyVim](https://www.lazyvim.org/) starter under `~/.config/nvim` (managed as `dot_config/nvim`). Requires **Neovim ≥ 0.11**; first launch or `nvim --headless "+Lazy! sync" +qa` installs plugins into `~/.local/share/nvim` (not in this repo).
- **tmux**: config under `~/.config/tmux` with [TPM](https://github.com/tmux-plugins/tpm) and [Catppuccin](https://github.com/catppuccin/tmux) (mocha). New panes use `/usr/bin/zsh` (same `~/.zshrc` as Ghostty). `chezmoi apply` clones TPM and installs plugins; update later with `prefix + I` in tmux.
- **fzf**: [junegunn/fzf](https://github.com/junegunn/fzf) for shell fuzzy finding and LazyVim pickers. Bash loads `~/.bashrc.d/fzf.sh`; zsh sources shared `~/.config/fzf/env.sh` then `fzf --zsh`. Neovim uses the LazyVim `fzf-lua` extra (`<leader>ff`, `<leader>fg`, etc.). Key bindings: `CTRL-T` (files), `CTRL-R` (history), `ALT-C` (cd).
- **zsh**: Bare modular config under `~/.config/zsh` (thin `~/.zshrc` loader) — no Oh My Zsh. [Starship](https://starship.rs/) prompt (`chezmoi apply` installs the binary to `~/.local/bin` when missing), [zoxide](https://github.com/ajeetdsouza/zoxide), Fedora packages for [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) / [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting), plus guarded `bat`/`eza` aliases. Ghostty defaults to zsh via `command = /usr/bin/zsh`. Leftover `~/.oh-my-zsh` / `~/.zsh/spaceship` from older applies can be removed manually.
- **Cursor global rules**: always-apply Agent preferences live in `~/.cursor/rules/*.mdc` (source: `dot_cursor/rules`). That is the portable replacement for Customize → User Rules. Edit with `chezmoi edit ~/.cursor/rules/...`, then `chezmoi apply`. Clear any leftover text in **Customize → User Rules** so rules are not double-injected. Per-repo `.cursor/` notes remain local working memory and stay gitignored in projects.
- **One tool to merge host differences**: [chezmoi](https://chezmoi.io/) templates and `data` values instead of forking the repo per machine.
- **Secrets never committed**: use ignored `*.local` files, `chezmoi edit` with encryption later (e.g. age), or a password manager—not this repository.

## Repository layout (chezmoi source)

From the repo root, paths map like this:

| In this repo        | On disk          |
|---------------------|------------------|
| `dot_config/foo`    | `~/.config/foo`  |
| `dot_cursor/rules`  | `~/.cursor/rules` (global Cursor Agent User Rules as `.mdc`) |
| `dot_bashrc`        | `~/.bashrc`      |
| `.chezmoi.toml.tmpl`| `~/.config/chezmoi/chezmoi.toml` (generated) |

Add files with chezmoi so names stay correct:

```bash
chezmoi add ~/.config/nvim
chezmoi add ~/.config/tmux/tmux.conf
```

Edit in the source tree or use `chezmoi edit ~/.config/nvim/init.lua`, then `chezmoi apply`.

## Prerequisites

- `git`, `make` (some Neovim plugins compile native parts)
- **zsh** (`zsh --version`; Fedora: `sudo dnf install zsh`)
- **fzf** (`fzf --version`; Fedora: `sudo dnf install fzf`)
- **zoxide** (`zoxide --version`; Fedora: `sudo dnf install zoxide`)
- **starship** — installed to `~/.local/bin` by `chezmoi apply` when missing ([starship.rs](https://starship.rs/))
- **tmux** (`tmux -V`)
- **Neovim ≥ 0.11** (`nvim --version`)
- [chezmoi](https://chezmoi.io/install/) installed and on `PATH`

Optional (zsh still starts without them):

```bash
sudo dnf install bat eza fd-find zsh-autosuggestions zsh-syntax-highlighting
```

### WSL notes

- Prefer **Linux line endings** in this repo (`git config core.autocrlf input` on Windows if you clone from Windows tools).
- Clipboard and paths differ from native Linux; keep machine-specific bits in chezmoi **templates** or **data** rather than separate branches.

## Bootstrap

From a fresh clone:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

To initialize chezmoi from this repo, run `./bootstrap.sh --init`. It uses the **Forgejo** clone URL by default (same idea as `git remote get-url origin` — SSH in this repo).

To use the **GitHub mirror** instead (e.g. no route to Forgejo), set `DOTFILES_REPO` first:

```bash
export DOTFILES_REPO='https://github.com/dougfinnie/dotfiles.git'
./bootstrap.sh --init
```

Or manually:

```bash
chezmoi init --apply 'ssh://git@mintie.grouse-matrix.ts.net:222/doug/dotfiles.git'
```

## Local overrides and secrets

- Files matching `*.local` and patterns in `.gitignore` are not tracked; use them for API keys, host-only paths, or `chezmoi.toml` overrides.
- For encrypted secrets in-repo, see [chezmoi encryption](https://chezmoi.io/user-guide/encryption/).

## License

Personal configuration; no license unless you add one.
