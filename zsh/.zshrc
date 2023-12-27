# We'll source everything from the .config directory at the end, but for now we need a few things to get started.
source ~/.config/zsh/options.zsh
source ~/.config/zsh/env.zsh

source ~/.oh-my-zsh/oh-my-zsh.sh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source "$(brew --prefix asdf)"/libexec/asdf.sh

for file in ~/.config/zsh/*; do source "$file"; done
