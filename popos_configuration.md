author: itwasneo

date: April 23 2024 - 09:30

---

1) Added new screen resolution option for the 2K external monitor following
the instructions described in dotfiles repo.
---
2) Installed Gnome Tweaks
---
3) Changed Firefox settings (privacy, search etc.)
---
4) Changed the default terminal to zsh. [source](https://www.debugpoint.com/install-use-zsh/)
    ```bash
    sudo apt install zsh
    chsh -s /usr/bin/zsh iwn
    ```
---
5) Updated the .zshrc file with the in dotfiles repo.
- IMPORTANT: I commented out the zsh-autocomplete package for now
---
6) Installed neovim following the official instructions. **IMPORTANT: Don't use apt-get**
- Downloaded the .tar file from [link](https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz)
    ```bash
    sudo apt update
    sudo apt install tar gzip build-essential
    sudo mv ~/Downloads/nvim-linux64.tar.gz /opt/
    cd /opt/
    tar xf nvim-linux64.tar.gz
    sudo chown -R $USER /opt/nvim-linux64	
    ```
- Added nvim executable directory to PATH in .zshrc	
---
7) Installed utils
    ```bash
    sudo apt install ripgrep xclip
---
8) Installed a nerd font (I like the FiraMono actually, nerd version might be good)
- **IMPORTANT: I decided to go  with JetBrains Mono again.**
- [Instructions](https://linuxspin.com/install-nerd-fonts-on-ubuntu/)
- [Nerd Font Official Site](https://www.nerdfonts.com/font-downloads)
- [Nerd Font Cheatsheet](https://www.nerdfonts.com/cheat-sheet)
- Downloaded the desired font JetBrains Mono in this case then unzip the
file to ~/.fonts, then install them.
    ```bash
    unzip Downloads/JetBrainsMono.zip -d ~/.fonts
    fc-cache -fv
    # To check installation
    fc-list | rg "JetBrains"
    ```
---
9) Installed Java dependencies
- openjdk-21-jre
- openjdk-21-jre-headless
- openjdk-21-jdk
- openjdk-21-doc
- openjdk-21-source
---
10) Installed IntelliJ Idea Community Edition
- Download the .tar file from [link](https://www.jetbrains.com/idea/download/?section=linux)
- Move .tar file to /opt
- Change the ownership of the unziped directory
    ```bash
    sudo tar xf ideaIC-2023.3.1.tar.gz
    sudo chown -R $USER /opt/idea-IC-233.11799.300
    ```
- Created a desktop entry file with the following content in ~/.local/share/applications/intellij.desktop
    ```bash
    [Desktop Entry]
    Name=IntelliJ Idea Community Edition
    Exec=/opt/idea-IC-233.11799.300/bin/idea.sh
    Icon=/opt/idea-IC-233.11799.300/bin/idea.png
    Comment=IDE for Java and Kotlin
    Type=Application
    Terminal=false
    Encoding=UTF-8
    Categories=Utility;
    ```
---
11) Installed Maven
- Download the .tar file from [link](https://maven.apache.org/download.cgi)
- Move the file to /opt
- Extract the content
- Add M2_HOME variable and update PATH
- Change the ownership of the new directory
---
12) Installed docker
- Follow the instruction in this [link](https://linuxhint.com/install-docker-on-pop_os/)
    ```bash
    sudo apt update
    sudo apt install  ca-certificates  curl  gnupg  lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    ```
- Post installation configurations [link](https://docs.docker.com/engine/install/linux-postinstall/)
    ```bash
    sudo groupadd docker
    sudo usermod -aG docker $USER
    ```
---
13) Installed github cli
- Follow the instructions in this [link](https://github.com/cli/cli/blob/trunk/docs/install_linux.mdu)
    ```bash
    type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
    ```
- Auth login
    ```bash
    gh auth login
    ```
---
14) Installed tmux
    ```bash
    sudo apt install tmux
    ```
---
15) Installed postman from their [official website](https://www.postman.com/downloads/)
- Download .tar file
- Install it as all the previous tar files.
---
16) At some point, I needed to solve a case for a job application. I had to 
install following libraries.

- zlib [official website](https://github.com/madler/zlib/releases/download/v1.3/zlib-1.3.tar.gz)
- upx [official website](https://github.com/upx/upx/releases/download/v4.2.1/upx-4.2.1-amd64_linux.tar.xz)
- graalvm [official website](https://www.graalvm.org/downloads/)
- x86_64-linux-musl-native [related GraalVM](https://www.graalvm.org/latest/reference-manual/native-image/guides/build-static-executables/)
---
17) Installed NodeJs from their [official website](https://nodejs.org/en/download)
- Download .tar file
- Install it as all the previous tar files.
---
18) Install Rust dependencies
- Insalling from [official site](https://rustup.rs/)
---
19) Change Alt+Tab behavior to switch between windows instad of applications?
- Open Settings -> Keyboard -> Keyboard Shortcuts (at the bottom)
- Search "Switch windows"
- The shorcut is disabled by default, set it to "Alt+Tab" (it will override the
default behavior)
---

# TODO:

- [ ] Install Thunderbird and setup Protonmail Bridge
    - Installed Thunderbird via pop!_shop
        UNINSTALLED
    - [ ] Protonmail Bridge exists in the shop as well. Check the version and
    official docs about the tool.
    - IMPORTANT: Proton Mail Bridge exists for only paid plan which around 3.5
    EUR minimum.
    - I'm not sure what to do. Definitely checkout [Mullvad](https://mullvad.net/en/account/login?next=%2Fen%2Faccount)
- [ ] Setup IdeaVim with the latest keymaps from work
