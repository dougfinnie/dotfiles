# Shared fzf defaults (sourced by bash and zsh before shell integration).
# https://github.com/junegunn/fzf#environment-variables

# Directories skipped by fzf's built-in file walker (CTRL-T, ALT-C, ** completion).
# Names only — no glob patterns. Add project-specific dirs here as needed.
_fzf_skip_dirs='.git,node_modules,target,.venv,venv,__pycache__,.cache,dist,build,.next,.nuxt,.turbo,coverage,.terraform,.gradle,.mypy_cache,.pytest_cache,.tox,.svn,.hg'

export FZF_DEFAULT_OPTS="--height 40% --layout reverse --border top --walker-skip=${_fzf_skip_dirs}"

export FZF_CTRL_T_OPTS="--walker-skip=${_fzf_skip_dirs}"
export FZF_ALT_C_OPTS="--walker-skip=${_fzf_skip_dirs}"
export FZF_COMPLETION_PATH_OPTS="--walker file,dir,follow,hidden --walker-skip=${_fzf_skip_dirs}"
export FZF_COMPLETION_DIR_OPTS="--walker dir,follow --walker-skip=${_fzf_skip_dirs}"

# Bare `fzf` (no pipe): prefer fd, then ripgrep, else built-in walker + skips above.
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --strip-cwd-prefix \
    --exclude .git --exclude node_modules --exclude target \
    --exclude .venv --exclude venv --exclude __pycache__ --exclude .cache \
    --exclude dist --exclude build --exclude .next --exclude .nuxt \
    --exclude .turbo --exclude coverage --exclude .terraform'
elif command -v rg >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow \
    -g "!.git/" -g "!node_modules/" -g "!target/" \
    -g "!.venv/" -g "!venv/" -g "!__pycache__/" -g "!.cache/" \
    -g "!dist/" -g "!build/" -g "!.next/" -g "!.nuxt/" \
    -g "!.turbo/" -g "!coverage/" -g "!.terraform/"'
fi

unset _fzf_skip_dirs
