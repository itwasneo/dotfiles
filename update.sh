#!/bin/bash

# tmux ------------------------------------------------------------------------
src_dir="$HOME"
dest_dir="$HOME/git/dotfiles"
filename=".tmux.conf"
cp "$src_dir/$filename" "$dest_dir"
echo "File $filename copied from $src_dir to $dest_dir"
# =============================================================================

