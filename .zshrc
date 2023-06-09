# Terminal Autocomplete
source $HOME/git/zsh-autocomplete/zsh-autocomplete.plugin.zsh
autoload -U colors && colors

# Decreasing the repeat delay, increasing repeat rate
xset r rate 200 50 

# History Size and Backup
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=2000
export SAVEHIST=$HISTSIZE
export EDITOR=/usr/bin/nvim
setopt hist_ignore_all_dups # Don't save duplicate commands
setopt hist_ignore_space # Trick to prevent particular entries from being recorded into history

export OPENSSL_DIR=/etc/ssl
export OPENSSL_LIB_DIR=/usr/lib
export OPENSSL_INCLUDE_DIR=/usr/include/openssl
export OPENSSL_STATIC=0

# Prompt
PS1="%{$fg[green]%}%D{%H:%M}  %{$fg[yellow]%}%m%{$reset_color%}::%{$fg[yellow]%}%1d%{$reset_color%} %"

# Path Variables
export PATH=/home/itwasneo/.local/bin:$PATH
export PATH=/home/itwasneo/.cargo/bin:$PATH
export PATH=/opt/apache-maven-3.9.3/bin:$PATH
export PATH=/opt/apache-jmeter-5.5/bin:$PATH
export PATH=/usr/lib/jvm/java-20-openjdk/bin:$PATH

# Java Paths
# export PATH=/opt/graalvm-ce-java19-22.3.1/bin:$PATH
# export GRAALVM_HOME=/opt/graalvm-ce-java19-22.3.1
export JAVA_HOME=/usr/lib/jvm/java-20-openjdk

# Ada Paths
export PATH=/opt/alr-1.2.2-bin-x86_64-linux/bin:$PATH # alire package manager for Ada

# fly io
export PATH=/home/itwasneo/.fly/bin:$PATH

# Util
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Command Modifications
alias ll='ls -AGghl --color=auto'

# Navigation
alias gg='cd ~/git'
alias g~='cd ~'
alias gw='cd ~/workspace'
alias gsb='cd ~/git/sb'

# Docker
alias dcud='docker-compose up -d'
alias dcd='docker-compose down'
alias dca='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

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
alias cbl='RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo build'
alias cblr='RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo build --release'

# zellij
alias z="zellij"

# pkg-config
export PKG_CONIG_PATH=/usr/lib/pkgconfig


# Autostart inside Zellij session
eval "$(zellij setup --generate-auto-start zsh)"
