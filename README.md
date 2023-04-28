# dotfiles
zsh, tmux, NeoVim

## About NeoVim
Although I'm still a dummy when it comes to **vim**, I configured this setup by myself. It is entirely lua based.There
are couple of links that I want to share which also influenced this configuration:

* [devaslife's NeoVim setup video](https://www.youtube.com/watch?v=ajmK0ZNcM4Q)
* [devaslife's NeoVim setup article](https://blog.inkdrop.app/my-neovim-setup-for-react-typescript-tailwind-css-etc-in-2022-a7405862c9a4)
* [chris@machine's NeoVim IDE from Scratch series](https://www.youtube.com/watch?v=ctH-a-1eUME&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ)

## About tmux with NeoVim conflict
I don't know why, but I spent too much time to support RGB colors in NeoVim inside a tmux session. Following line that
should reside in your `.tmux.conf` file was the answer for me.

```
set-option -s terminal-features ",*256col*:RGB"
```
