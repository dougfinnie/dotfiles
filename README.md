# Dotfiles (Linux / WSL)

Central configuration for machines you control. Layout follows **XDG**: everything lives under `~/.config` (and a few top-level dotfiles when you add them) so paths stay predictable across distros.

## Principles

- **Neovim “Option A”**: target **Neovim ≥ 0.11** (distro packages are fine). Plugin pins stay compatible with 0.11 until every device can move to **0.12+** together; then you can drop pins and align with upstream Kickstart.
- **One tool to merge host differences**: [chezmoi](https://chezmoi.io/) templates and `data` values instead of forking the repo per machine.
- **Secrets never committed**: use ignored `*.local` files, `chezmoi edit` with encryption later (e.g. age), or a password manager—not this repository.

## Repository layout (chezmoi source)

From the repo root, paths map like this:

| In this repo        | On disk          |
|---------------------|------------------|
| `dot_config/foo`    | `~/.config/foo`  |
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
- **Neovim ≥ 0.11** (`nvim --version`)
- [chezmoi](https://chezmoi.io/install/) installed and on `PATH`

### WSL notes

- Prefer **Linux line endings** in this repo (`git config core.autocrlf input` on Windows if you clone from Windows tools).
- Clipboard and paths differ from native Linux; keep machine-specific bits in chezmoi **templates** or **data** rather than separate branches.

## Bootstrap

From a fresh clone:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

To initialize chezmoi from this repo (adjust the URL for your fork):

```bash
export DOTFILES_REPO='https://github.com/dougfinnie/dotfiles.git'
./bootstrap.sh --init
```

Or manually:

```bash
chezmoi init --apply https://github.com/dougfinnie/dotfiles.git
```

(Use your real repository URL.)

## Local overrides and secrets

- Files matching `*.local` and patterns in `.gitignore` are not tracked; use them for API keys, host-only paths, or `chezmoi.toml` overrides.
- For encrypted secrets in-repo, see [chezmoi encryption](https://chezmoi.io/user-guide/encryption/).

## License

Personal configuration; no license unless you add one.
