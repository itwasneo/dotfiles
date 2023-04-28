#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# tmux ------------------------------------------------------------------------
src_dir="$HOME"
dest_dir="$HOME/git/dotfiles"
filename=".tmux.conf"
if cp "$src_dir/$filename" "$dest_dir"; then
    echo -e "${GREEN}  ${NC}tmux configuration is updated."
fi
# =============================================================================


# zsh -------------------------------------------------------------------------
src_dir="$HOME"
dest_dir="$HOME/git/dotfiles"
filename=".zshrc"
if cp "$src_dir/$filename" "$dest_dir"; then
    echo -e "${GREEN}  ${NC}zsh configuration is updated."
fi
# =============================================================================


# NeoVim ----------------------------------------------------------------------
src_dir="$HOME/.config"
dest_dir="$HOME/git/dotfiles"
filename="nvim"
if cp -r "$src_dir/$filename" "$dest_dir"; then
    echo -e "${GREEN}  ${NC}NeoVim configuration is updated."
fi
# =============================================================================
