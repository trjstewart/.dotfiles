# configure shell history
setopt appendhistory histignorealldups
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# zsh theme
ZSH_THEME=robbyrussell
# shellcheck source=/dev/null
source ~/.oh-my-zsh/oh-my-zsh.sh

# load brew and asdf
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# shellcheck source=/dev/null
source "$(brew --prefix asdf)"/libexec/asdf.sh

# load custom zsh config
for file in ~/.config/zsh/*; do source "$file"; done