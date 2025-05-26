export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

export EDITOR="code"

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME=robbyrussell
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_BUNDLE_FILE="$HOME/.dotfiles/Brewfile"

if [[ -e ~/.env ]]; then source ~/.env; fi
