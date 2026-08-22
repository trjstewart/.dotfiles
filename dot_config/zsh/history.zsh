HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE

setopt extended_history        # record timestamp of command in HISTFILE
setopt hist_ignore_all_dups    # remove older duplicates anywhere in the list, not just consecutive ones
setopt hist_save_no_dups       # don't write a duplicate event to HISTFILE
setopt hist_find_no_dups       # don't show duplicates when searching history
setopt hist_ignore_space       # ignore commands that start with space
setopt hist_reduce_blanks      # strip superfluous whitespace before recording
setopt hist_no_store           # don't record `history` invocations themselves
setopt hist_verify             # show command with history expansion to user before running it
setopt hist_fcntl_lock         # use fcntl locking, safer and faster than the default
setopt inc_append_history_time # write each command as it finishes without importing other sessions' history
