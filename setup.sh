#!/bin/bash

# Debian Post-Install Setup Script

set -e

read -p "Enter your username: " USERNAME

HOME_DIR="/home/$USERNAME"
i3_CONFIG_FILE="$HOME_DIR/.config/i3/config"
LOCAL_GIT_DIR="$HOME_DIR/git"
DOTFILES_REPO="https://github.com/itwasneo/dotfiles.git"
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
NERD_FONT_ZIP="/tmp/JetBrainsMono.zip"
NERD_FONT_DIR="$HOME_DIR/.local/share/fonts/JetBrainsMono"
NEOVIM_INSTALLATION_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
NEOVIM_EXECUTABLE_PATH="$HOME_DIR/.local/bin/nvim"
TEAMSPEAK_TAR="teamspeak-client.tar.gz"
TEAMSPEAK_DOWNLOAD_URL="https://files.teamspeak-services.com/pre_releases/client/6.0.0-beta2/$TEAMSPEAK_TAR"
TEAMSPEAK_INSTALLATION_PATH="/opt/teamspeak"
TEAMSPEAK_EXECUTABLE_PATH="$HOME_DIR/.local/bin/teamspeak"
SDKMAN_INSTALLATION_PATH="/opt/sdkman"
SDKMAN_EXECUTABLE_PATH="$HOME_DIR/.local/bin/sdkman"


mkdir -p "$LOCAL_GIT_DIR"

if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root (try 'su -' first)."
	exit 1
fi

echo "[STEP 1] Installing sudo passwd if not present..."
apt update
apt install -y sudo passwd

echo "[STEP 2] Adding user $USERNAME to sudo group..."
usermod -aG sudo "$USERNAME"

echo "[STEP 3] Installing essential utilities: vim, curl, wget, htop, iproute2, unzip, ripgrep, fd-find, luarocks, pip3"
apt install -y vim curl wget htop iproute2 unzip ripgrep fd-find luarocks python3-pip

echo "[STEP 4] Installing build-essential(gcc, make, etc.)"
apt install -y build-essential

echo "[STEP 5] Installing git"
apt install -y git

echo "[STEP 6] Installing zsh"
apt install -y zsh
chsh -s /bin/zsh "$USERNAME"

echo "[STEP 7] Installing Xorg, i3 and xinit"
apt install -y xorg i3 xinit x11-xserver-utils dbus-x11 xfonts-base x11-utils

grep -q '^exec i3$' $HOME_DIR/.xinitrc 2>/dev/null || echo "exec i3" >> $HOME_DIR/.xinitrc

if ! grep -q "setxkbmap -option ctrl:nocaps" "$HOME_DIR/.xinitrc"; then
	sed -i '/exec i3/i setxkbmap -option ctrl:nocaps' "$HOME_DIR/.xinitrc"
	echo "[STEP 8] Caps Lock remapped to CTRL"
else
	echo "[STEP 8] Caps Lock already remapped to CTRL"
fi

echo "[STEP 9] Disabling sleep/suspend"
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target --no-pager || true

echo "[STEP 10] Preventing closing lid actions"
sudo sed -i \
	-e '/^#\?HandleLidSwitch=/ s/.*/HandleLidSwitch=ignore/' \
	-e '/^#\?HandleLidSwitchDocked=/ s/.*/HandleLidSwitchDocked=ignore/' \
	-e '/^#\?HandleSuspendKey=/ s/.*/HandleSuspendKey=ignore/' \
	-e '/^#\?HandleHibernateKey=/ s/.*/HandleHibernateKey=ignore/' \
	/etc/systemd/logind.conf

# You can't restart systemd-logind in a graphical session
if [ -z "$DISPLAY" ]; then
	echo "[STEP 11] Restarting systemd-logind..."
	sudo systemctl restart systemd-logind
else
	echo "[STEP 11] Skipping systemd-logind restart (in graphical session)"
fi

echo "[SETUP 12] Installing Firefox-esr"
apt install -y firefox-esr

if ! grep -q 'exec firefox-esr' $i3_CONFIG_FILE 2>/dev/null; then
	echo "[STEP 13] Browser mapped to mod+b"
	echo 'bindsym  $mod+b exec firefox-esr' >> $i3_CONFIG_FILE
else
	echo "[STEP 13] Browser shortcut already configured"
fi

echo "[SETUP 14] Installing Alacritty"
apt install -y alacritty

if ! grep -q '^set \$term ' "$i3_CONFIG_FILE"; then
	echo "[STEP 15] Setting alacritty as default terminal"
	echo 'set $term alacritty' >> "$i3_CONFIG_FILE"
else
	echo "[STEP 15] Changing alacritty as default terminal"
	sed -i 's|^set \$term .*|set $term alacritty|' "$i3_CONFIG_FILE"
fi

if grep -q '^bindsym \$mod+Return' "$i3_CONFIG_FILE"; then
	echo "[STEP 16] Changing alacritty shortcut"
	sed -i 's|^bindsym \$mod+Return .*|bindsym $mod+Return exec $term|' "$i3_CONFIG_FILE"
else
	echo "[STEP 16] Setting alacritty shortcut"
	echo 'bindsym $mod+Return exec $term' >> "$i3_CONFIG_FILE"
fi

if [ ! -d "$NERD_FONT_DIR" ]; then
	echo "[STEP 17] Installing JetBrain Mono Nerd font"
	wget "$NERD_FONT_URL" -O "$NERD_FONT_ZIP"
	mkdir -p $NERD_FONT_DIR
	unzip -o "$NERD_FONT_ZIP" -d "$NERD_FONT_DIR"
	fc-cache -fv
else
	echo "[STEP 17] JetBrains Mono Nerd Font already installed"
fi

if grep -q '^font ' "$i3_CONFIG_FILE"; then
	echo "[STEP 18] Setting font"
	sed -i 's|^font .*|font pango:JetBrainsMono Nerd Font 11|' "$i3_CONFIG_FILE"
else
	echo "[STEP 18] Setting font"
	echo "font pango:JetBrainsMono Nerd Font 11" >> "$i3_CONFIG_FILE"
fi

echo "[STEP 19] Configuring clipboard"
apt install -y xclip xsel 

if [ ! -f "$HOME_DIR/.cargo/bin/rustc" ]; then
	echo "[STEP 20] Installing Rust toolchain using rustup"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
	echo "[STEP 20] Rust toolchain already installed"
fi

mkdir -p $HOME_DIR/.local/bin
if ! command -v $NEOVIM_EXECUTABLE_PATH >/dev/null; then
	echo "[SETUP 21] Installing neovim"
	curl -Lo $NEOVIM_EXECUTABLE_PATH $NEOVIM_INSTALLATION_URL
	chmod +x $NEOVIM_EXECUTABLE_PATH  
	chown $USERNAME:$USERNAME $NEOVIM_EXECUTABLE_PATH
else
	echo "[SETUP 21] neovim is already installed"
fi

if [ ! -d "$LOCAL_GIT_DIR/dotfiles" ]; then
	echo "[SETUP 22] Cloning dotfiles"
	sudo -u $USERNAME git clone "$DOTFILES_REPO" "$LOCAL_GIT_DIR/dotfiles"
else
	echo "[SETUP 22] dotfiles repository already cloned"
fi

if ! command -v $TEAMSPEAK_EXECUTABLE_PATH >/dev/null; then
	echo "[SETUP 23] Installing teamspeak"
	wget "$TEAMSPEAK_DOWNLOAD_URL" -O /tmp/$TEAMSPEAK_TAR
	mkdir -p /opt/teamspeak
	tar -xvzf /tmp/$TEAMSPEAK_TAR -C $TEAMSPEAK_INSTALLATION_PATH
	ln -s $TEAMSPEAK_INSTALLATION_PATH/TeamSpeak $TEAMSPEAK_EXECUTABLE_PATH 
	rm /tmp/$TEAMSPEAK_TAR
else
	echo "[SETUP 23] teamspeak is already installed"
fi

# sdkman installation script already checks for the previous installations' existence
echo "[SETUP 24] Installing sdkman"
sudo -u $USERNAME bash -c "curl -s 'https://get.sdkman.io?ci=true&rcupdate=false' | bash"

# [ ] RUN dotfiles configuration script

echo "[CLEANING...]"
apt autoremove -y || true

i3-msg reload
i3-msg restart

echo "[FINAL] Setup complete. Please log out and log back in as $USERNAME to apply changes."

