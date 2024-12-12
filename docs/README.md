# General

## System Settings

- [X] Change the `Repeat Keys` Setting

`Settings -> Accessibility -> Typing -> Typing Assist -> Repeat Keys`

**Increase** the `Speed`, **decrease** the `Delay` (DO NOT MAXED THEM OUT)

- [X] Change the mouse speed to somewhere over the lowest. Close the mouse acceleration

- [X] Change default shell to `zsh`

- [X] Install `JetBrainsMono Nerd Font`

	- Download the zip file from `https://www.nerdfonts.com/font-downloads` 

	- Unzip file to `~/.fonts` directory

	- Run `fc-cache -fv`

- [X] Change `screen blank` under Power settings to `Never`

- [X] Change cursor size under `Accessibility -> Seeing -> Cursor Size`

---

## Terminal (default gnome terminal)

- [X] Rename the profile to `iwn`

- [X] Disable `Terminal Bell`

- [X] Change color scheme to `Solarized Dark`

- [X] Change font to `JetBrainsMono Nerd Font`, and change the size to 15

---

## File System

- [X] Create `git` and `workspace` folders in home directory
 
---

## Applications

- [X] Install `zsh` and make it default shell

- [X] Install `tmux`

- [X] Install `git`

- [X] Install `alacritty`
	- Follow https://github.com/alacritty/alacritty/blob/master/INSTALL.md
	- [ ] IMPORTANT: DIDN'T FINISH WITH THE SHELL COMPLETIONS PART
	- [X] Set Alacritty as default terminal emulator with the following command
	`gsettings set org.gnome.desktop.default-applications.terminal exec '/usr/local/bin/alacritty'`
	- [X] After setting it as default, `CTRL+ALT+T` will open Alacritty automatically
	- [X] Installation doesn't create a config file automatically, so create a config file:

	```
	mkdir $HOME/.config/alacritty
	touch $HOME/.config/alacritty/alacritty.toml
	```
- [X] Install `sdkman`
	- [X] Follow https://sdkman.io/install/

- [X] Install `Intellij Community`

- [ ] Install `wireguard`
    - [ ] Download VPN server configs for `Surfshark` and `Mullvad`

- [ ] Install chromium

- [ ] Install `neovim`

- [ ] Install `docker`

- [ ] Install `thunderbird` for email
    - [ ] Integrate `protonmail`

---

## Programming

- [X] Installed oracle java 22 via sdkman

- [X] Install java 21.0.5-oracle via sdk man and set as default

- [X] Installed gradle 8.11 via sdkman



## Configuration

- [X] Clone your own `dotfiles` repo

- [X] Change Firefox privacy settings such as cookies



## System Dependencies

- [X] build-essential
