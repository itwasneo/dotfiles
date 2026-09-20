# --- HISTORY SETTINGS ---
HISTFILE=~/.zsh_history    # Where the history is stored
HISTSIZE=100000             # How many lines to keep in the current session
SAVEHIST=100000             # How many lines to save in the history file

# --- HISTORY BEHAVIOR ---
setopt append_history       # Don't overwrite the file, append to it
setopt inc_append_history   # Write to the file as soon as a command is executed
setopt share_history        # Share history between all active sessions/tmux windows
setopt hist_ignore_dups     # Don't record a command if it was just recorded
setopt hist_ignore_space    # Don't record commands starting with a space

autoload -U colors && colors

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

# copy clipboard
alias cpwd='pwd | tr -d "\n" | xclip -selection clipboard'

# Add custom completions to fpath
fpath=(~/.zsh/completions $fpath)

# Faster compinit: only regenerate cache if it's older than 24h
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi

# anythingllm start
# Function to start AnythingLLM
start_anythingllm() {
    export STORAGE_LOCATION="$HOME/anythingllm"
    mkdir -p "$STORAGE_LOCATION"
    touch "$STORAGE_LOCATION/.env"
    
    # Check if container is already running and remove it to avoid name conflicts
    docker rm -f anythingllm 2>/dev/null
    
    docker run -d -p 3001:3001 \
    --name anythingllm \
    -v "${STORAGE_LOCATION}:/app/server/storage" \
    -v "${STORAGE_LOCATION}/.env:/app/server/.env" \
    -e STORAGE_DIR="/app/server/storage" \
    mintplexlabs/anythingllm
    
    echo "AnythingLLM is starting at http://localhost:3001"
}

# OLLAMA
export OLLAMA_MAX_VRAM_OVERHEAD=0
export OLLAMA_FLASH_ATTENTION=1
export OLLAMA_KV_CACHE_TYPE=q4_0

# JAVA
export JAVA_HOME=$HOME/.sdkman/candidates/java/current

# HADOOP
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native

# SPARK
export SPARK_HOME=/opt/spark/current
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export SPARK_LOCAL_IP="127.0.0.1"

# UV
. "$HOME/.local/bin/env"

# CLAUDE
CLAUDE_CODE_MAX_OUTPUT_TOKENS=100000

# GO
export PATH=$PATH:/usr/local/go/bin

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# fnm
FNM_PATH="/home/itwasneo/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

# bun completions
[ -s "/home/itwasneo/.bun/_bun" ] && source "/home/itwasneo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions
export PI_DICTATE_ARECORD_DEVICE=pipewire
