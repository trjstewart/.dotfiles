# We'll source everything from the .config directory at the end, but for now we need a few things to get started.
source ~/.config/zsh/options.zsh
source ~/.config/zsh/env.zsh

source $ZSH/oh-my-zsh.sh
if [[ "$(uname -s)" == "Darwin" ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
if [[ "$(uname -s)" == "Linux" ]]; then eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; fi
source "$(brew --prefix asdf)"/libexec/asdf.sh

for file in ~/.config/zsh/*.zsh; do source "$file"; done
