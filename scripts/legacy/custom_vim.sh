#!/usr/bin/bash

set -e

# Variables
VIM_DIR="$HOME/git/vim"
INSTALL_PREFIX="/usr/local"

# Install dependencies
sudo apt update
sudo apt install -y git build-essential ncurses-dev python3-dev libacl1-dev libgpm-dev libx11-dev libxt-dev

# Clean up previous clone
rm -rf $VIM_DIR

# Clone Vim source
echo "...Cloning Vim source code into $VIM_DIR..."
git clone --depth=1 https://github.com/vim/vim.git "$VIM_DIR"

cd $VIM_DIR

# Configure Vim(terminal only, clipboard enabled)
echo "...Configuring Vim build..."
./configure \
	--with-features=huge \
	--enable-multibyte \
	--enable-terminal \
	--enable-cscope \
	--disable-gui \
	--prefix="$INSTALL_PREFIX"

# Compile Vim
echo "...Building Vim..."
make -j"$(nproc)"

# Install Vim
echo "...Installing Vim..."
sudo make install

echo "...Vim successfully compiled and installed to $INSTALL_PREFIX/bin/vim"
vim --version | head -n 10

