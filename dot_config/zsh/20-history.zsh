HISTFILE=${HISTFILE:-$HOME/.histfile}
HISTSIZE=50000
SAVEHIST=50000

setopt SHARE_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY
# IGNORE_ALL_DUPS: one copy of each command (latest wins). FIND_NO_DUPS: Ctrl-R skips repeats.
# EXPIRE_DUPS_FIRST: when trimming, drop duplicates before unique lines. Leading space still ignored.
setopt HIST_IGNORE_ALL_DUPS HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY
