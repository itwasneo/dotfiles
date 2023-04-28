#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print the help message
print_help() {
  echo "Usage: $0 [-h] [-s|-u]"
  echo "Options:"
  echo "  -h  Print this help message"
  echo "  -s  Setup: copy configuration files to local machine"
  echo "  -u  Update: copy local configuration files to Git repository"
}

# Either update or setup option can be picked
count=0

while getopts "hsu" opt; do
    case $opt in
        s) if [ $count -eq 0 ]; then
                echo -e "${GREEN}  ${NC}Setting Up:"

                # source and destination
                src_dir="$HOME/git/dotfiles"
                dest_dir="$HOME"
                
                # tmux ------------------------------------------------------------------------
                filename=".tmux.conf"
                if cp "$src_dir/$filename" "$dest_dir"; then
                    echo -e "${GREEN}  ${NC}tmux is ready."
                fi
                # =============================================================================


                # zsh -------------------------------------------------------------------------
                filename=".zshrc"
                if cp "$src_dir/$filename" "$dest_dir"; then
                    echo -e "${GREEN}  ${NC}zsh is ready."
                fi
                # =============================================================================


                # NeoVim ----------------------------------------------------------------------
                dest_dir="$HOME/.config" # changing source for NeoVim!!
                filename="nvim" # this is a folder
                if cp -r "$src_dir/$filename" "$dest_dir"; then
                    echo -e "${GREEN}  ${NC}NeoVim is ready."
                fi
                # =============================================================================
                count=1
            else
                echo -e "${RED}   Only one of the -s or -u options can be used."
                exit 1
            fi
            ;;
        u) if [ $count -eq 0 ]; then
                echo -e "${GREEN} 󰚰 ${NC}Updating:" 

                # source and destination
                src_dir="$HOME"
                dest_dir="$HOME/git/dotfiles"
                
                # tmux ------------------------------------------------------------------------
                filename=".tmux.conf"
                if cp "$src_dir/$filename" "$dest_dir"; then
                    echo -e "${GREEN}  ${NC}tmux configuration is updated."
                fi
                # =============================================================================


                # zsh -------------------------------------------------------------------------
                filename=".zshrc"
                if cp "$src_dir/$filename" "$dest_dir"; then
                    echo -e "${GREEN}  ${NC}zsh configuration is updated."
                fi
                # =============================================================================


                # NeoVim ----------------------------------------------------------------------
                src_dir="$HOME/.config" # changing source for NeoVim!!
                filename="nvim" # this is a folder
                if cp -r "$src_dir/$filename" "$dest_dir"; then
                    echo -e "${GREEN}  ${NC}NeoVim configuration is updated."
                fi
                # =============================================================================
                count=1
            else
                echo -e "${RED}   Only one of the -s or -u options can be used."
                exit 1
            fi
            ;;
        h) # Help
          print_help
          exit 0
          ;;
        \?) # Invalid option
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

# Check if no options were provided
if [ $count -eq 0 ]; then
  echo "Usage: $0 [-s|-u]"
  exit 1
fi
