# https://zsh.sourceforge.io/Doc/Release/Options.html

# Changing Directories
setopt auto_cd
setopt auto_pushd
setopt cd_silent
setopt chase_links
setopt pushd_ignore_dups
setopt pushd_to_home

# Completion
setopt always_to_end
setopt auto_list
setopt auto_param_keys
setopt complete_in_word

# History
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history_time

# Input/Output
setopt interactive_comments

# Prompting
setopt prompt_subst

# Shell State
setopt interactive
setopt login

# Zle
setopt zle
