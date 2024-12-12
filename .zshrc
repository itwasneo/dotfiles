# direcotory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# download zinit, if it is not existed
if [ ! -d "${ZINIT_HOME}" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# source/load zinit
source "${ZINIT_HOME}/zinit.zsh"

# avoid lagging due to nvm load
export NVM_LAZY_LOAD=true

# zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light lukechilds/zsh-nvm

#autoload -U colors && colors
autoload -Uz compinit

# keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# history
HIST_SIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HIST_SIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# completion style
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

zinit cdreplay -q

# fzf integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Prompt
PS1="%{$fg[green]%}%D{%H:%M} 󰶵 %{$fg[yellow]%}%m%{$fg[green]%}  %{$fg[yellow]%}%1d%{$reset_color%} %"

# Util
alias ls='ls --color'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Command Modifications
alias ll='ls -AGghl --color=auto'

# Navigation
alias gg='cd ~/git'
alias g~='cd ~'
alias gw='cd ~/workspace'

# Docker
alias dcud='docker-compose up -d'
alias dcd='docker-compose down'
alias dca='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

alias clip="xclip -sel cli"

function drmid {
    if [ "$1" = "-f" ]; then
        echo "Flag -f detected"
        docker rmi -f $(docker images -f "dangling=true" -q)
    elif [ -z "$1" ]; then
        docker rmi $(docker images -f "dangling=true" -q)
    else
        echo "Invalid argument. Only '-f' for 'force' is allowed."
    fi
}

# cargo
alias cbm='RUSTFLAGS="-C link-arg=-fuse-ld=mold" cargo build'
alias cbmr='RUSTFLAGS="-C link-arg=-fuse-ld=mold" cargo build --release'

export PATH=$PATH:/opt/idea-IC-243.21565.193/bin						# Intellij IDEA Community Edition
export PATH=$PATH:/opt/nvim-linux64/bin									# neovim
export SDKMAN_DIR=$HOME/.sdkman											# sdkman	


export NVM_DIR="$HOME/.nvm"

source ~/workspace/script/enable_sdkman.sh
