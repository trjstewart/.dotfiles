for file in ~/.config/zsh/*; do source "$file"; done

source ~/.oh-my-zsh/oh-my-zsh.sh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source "$(brew --prefix asdf)"/libexec/asdf.sh

for file in ~/.config/zsh/*; do source "$file"; done
