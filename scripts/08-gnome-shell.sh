#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

FD_VERSION="7.3.0"
AUTOKEY_VERSION="0.95.7"

cp images/*.jpeg ~/Pictures/

sudo chown $(id -u):$(id -g) ~/.config/monitors.xml

sudo apt install \
    appmenu-gtk3-module \
    network-manager-openconnect-gnome \
    chrome-gnome-shell gnome-tweak-tool dconf-editor

mkdir -p ~/.local/share/gnome-shell/extensions
mkdir -p ~/.cinnamon-gnome/configs/gnomeGlobalAppMenu@lestcape
unzip gnomeGlobalAppMenu@lestcape.zip -d ~/.local/share/gnome-shell/extensions
cp ./gnomeGlobalAppMenu@lestcape.json ~/.cinnamon-gnome/configs/gnomeGlobalAppMenu@lestcape/

# Install OSX fonts
sudo unzip mac-fonts.zip -d /usr/share/fonts; sudo fc-cache -f -v;

# Install OSX cursors
tar -xvjf 175749-OSX-ElCap.tar.bz2 \
 && cd OSX-ElCap && sudo ./install.sh \
 && cd - && rm -rf OSX-ElCap

# Install sierra-gtk-theme
sudo add-apt-repository -y ppa:dyatlov-igor/sierra-theme
sudo apt install -y sierra-gtk-theme-git

# Install autokey
wget https://github.com/autokey/autokey/releases/download/v${AUTOKEY_VERSION}/autokey-common_${AUTOKEY_VERSION}-0_all.deb \
 && wget https://github.com/autokey/autokey/releases/download/v${AUTOKEY_VERSION}/autokey-gtk_${AUTOKEY_VERSION}-0_all.deb \
 && sudo dpkg --install autokey-*.deb \
 && sudo apt --fix-broken install \
 && rm -rf autokey-*.deb \
 && mkdir -p ~/.config && cp -r autokey ~/.config/

# install fd
wget https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd_${FD_VERSION}_amd64.deb \
 && sudo dpkg -i fd_*.deb && rm -rf fd_*.deb

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
echo -e '
alias fd=fdfind

# Set fd as the default source for fzf
# Follow symbolic links, search hidden files, exclude gitignored files
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER="~~"

# Options to fzf command
export FZF_COMPLETION_OPTS="+c -x"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
' >> ~/.bashrc
