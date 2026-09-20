# dotfiles

Personal Linux/macOS-ish configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a Stow package that mirrors paths under `$HOME`.

```text
zsh/        -> ~/.zshrc
tmux/       -> ~/.tmux.conf
alacritty/  -> ~/.config/alacritty/alacritty.toml
nvim/       -> ~/.config/nvim
vim/        -> ~/.vimrc
ideavim/    -> ~/.ideavimrc
```

Legacy scripts that are not part of the normal install flow live under `scripts/legacy/`.

## Install

Install GNU Stow first:

```bash
sudo apt install stow
```

Then clone this repo and stow packages individually:

```bash
cd ~/git/dotfiles
stow zsh
stow tmux
stow alacritty
stow nvim
stow vim
stow ideavim
```

## Uninstall links

```bash
stow -D zsh tmux alacritty nvim vim ideavim
```

## Notes

- The repo is the source of truth. Edit files here, not the symlink targets.
- `lazy-lock.json` is ignored because it is machine/plugin-state specific for this setup.
