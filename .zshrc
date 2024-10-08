# Terminal Autocomplete

# source $HOME/git/zsh-autocomplete/zsh-autocomplete.plugin.zsh
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

#export OPENSSL_DIR=/etc/ssl
#export OPENSSL_LIB_DIR=/usr/lib
#export OPENSSL_INCLUDE_DIR=/usr/include/openssl
#export OPENSSL_STATIC=0

# Prompt
PS1="%{$fg[green]%}%D{%H:%M} 󰶵 %{$fg[yellow]%}%m%{$fg[green]%}  %{$fg[yellow]%}%1d%{$reset_color%} %"


# Java Paths
# export PATH=/opt/graalvm-ce-java19-22.3.1/bin:$PATH
export GRAALVM_HOME=/opt/graalvm-jdk-21.0.1+12.1
export M2_HOME=/opt/apache-maven-3.9.6/
export CARGO_HOME=$HOME/.cargo/
#export TOOLCHAIN_DIR=/opt/x86_64-linux-musl-native
#export CC=$TOOLCHAIN_DIR/bin/gcc
#export TOOLCHAIN_DIR=/usr/lib/gcc/x86_64-linux-gnu 
#export CC=$TOOLCHAIN_DIR/bin/gcc
#export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUNNER=$CC

# Path Variables
export PATH=/home/itwasneo/.local/bin:$PATH
export PATH=/opt/nvim-linux64/bin:$PATH                     # neovim
export PATH=/opt/apache-maven-3.9.6/bin:$PATH               # maven
#export PATH=$TOOLCHAIN_DIR/bin:$PATH                       # musl
export PATH=/opt/upx-4.2.1-amd64_linux:$PATH                # upx
export PATH=/opt/graalvm-jdk-21.0.1+12.1/bin:$PATH          # graalvm
export PATH=/opt/gradle/gradle-8.6/bin:$PATH                # gradle
export PATH=/opt/node-v20.10.0-linux-x64/bin:$PATH          # nodejs
export PATH=/usr/local/go/bin:$PATH                         # Go
export PATH=/home/iwn/.npm-global/bin:$PATH                 # npm-global
export PATH=/opt/circleci-cli_0.1.30549_linux_amd64:$PATH   # circleci
export PATH=/home/iwn/.local/bin:$PATH                      # after pip upgrade, it warned about this
export PATH=/home/iwn/.sdkman/candidates/java/17.0.11-oracle:$PATH
# export PATH=/home/itwasneo/.cargo/bin:$PATH
# export PATH=/opt/apache-jmeter-5.5/bin:$PATH

# Ada Paths
# export PATH=/opt/alr-1.2.2-bin-x86_64-linux/bin:$PATH # alire package manager for Ada

# fly io
# export PATH=/home/itwasneo/.fly/bin:$PATH

# Util
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Command Modifications
alias ll='ls -AGghl --color=auto'

# Navigation
alias gg='cd ~/git'
alias g~='cd ~'
alias ws='cd ~/workspace'
alias sb='cd ~/git/sb'
alias zs='cd ~/zs'

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
alias cbm='RUSTFLAGS="-C link-arg=-fuse-ld=mold" cargo build'
alias cbmr='RUSTFLAGS="-C link-arg=-fuse-ld=mold" cargo build --release'

# zellij
# alias z="zellij"

# pkg-config
export PKG_CONIG_PATH=/usr/lib/pkgconfig
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_ALL_STATIC=1
export PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1
export PKG_CONFIG_ALLOW_SYSTEM_LIBS=1
export OPENSSL_SYS_USE_PKG_CONFIG=1
export ZSTD_SYS_USE_PKG_CONFIG=1

# Autostart inside Zellij session
# eval "$(zellij setup --generate-auto-start zsh)"

# Airflow
export AIRFLOW_HOME=~/airflow


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
