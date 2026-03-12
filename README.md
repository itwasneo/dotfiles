# dotfiles ⚙️

set deez dots

## About **dotfiles** script

I'm trying to convert my entire development setup from bash scripts to ansible playbooks progressively. This file serves as a
starting point for the further automation with ansible playbooks. If you want to learn about the details checkout:

- [TheAltF4Stream's great video](https://www.youtube.com/watch?v=V_Cj_p6se3k)

## About .sh files

I'm configuring and keeping my setups updated through .sh files.

### dot.sh

This is for updating and setting up the local configuration files of following programs:

- zsh
- tmux
- NeoVim with NvChad

## About tmux with NeoVim conflict

I don't know why, but I spent too much time to support RGB colors in NeoVim inside a tmux session. Following line that
should reside in your `.tmux.conf` file was the answer for me.

```
set-option -s terminal-features ",*256col*:RGB"
```
