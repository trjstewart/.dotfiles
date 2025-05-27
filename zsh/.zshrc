# We'll source everything from the .config directory at the end, but for now we need a few things to get started.
source ~/.config/zsh/options.zsh
source ~/.config/zsh/env.zsh
source ~/.config/zsh/plugins.zsh

source $ZSH/oh-my-zsh.sh
if [[ "$(uname -s)" == "Darwin" ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
if [[ "$(uname -s)" == "Linux" ]]; then eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; fi
source "$(brew --prefix asdf)"/libexec/asdf.sh

# For good measure, source everything in the .config/zsh directory.
for file in ~/.config/zsh/*.zsh; do source "$file"; done

# Only rebuild the completion cache if it's older than one day. This prevents unnecessary rebuilds and speeds up shell startup.
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi
