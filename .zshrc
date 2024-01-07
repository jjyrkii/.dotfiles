# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh/"

# theme
ZSH_THEME="robbyrussell"

# oh-my-zsh updates
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# fancy autocomplete waiting dots
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
COMPLETION_WAITING_DOTS="true"

# history
HIST_STAMPS="%d/%m/%Y %T"
HISTCONTROL=ignoreboth:erasedups

# plugins
plugins=(
    sudo
    git 
)

source $ZSH/oh-my-zsh.sh

# aliases
alias ls="ls --color=auto"
alias ll="ls -lah"
alias cd..="cd .."
alias grep="grep --color=auto"
alias vim=nvim

# path

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$PATH:/usr/local/go/bin
