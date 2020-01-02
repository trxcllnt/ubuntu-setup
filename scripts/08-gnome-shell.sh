#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

mkdir -p ~/Pictures && cp images/*.jpeg ~/Pictures/

sudo apt install -y \
    appmenu-gtk3-module \
    network-manager-openconnect-gnome \
    chrome-gnome-shell gnome-tweak-tool dconf-editor

# Install sierra-gtk-theme
sudo add-apt-repository -y ppa:dyatlov-igor/sierra-theme \
 && sudo apt install -y sierra-gtk-theme-git

# Install OSX fonts
sudo unzip -q mac-fonts.zip -d /usr/share/fonts; sudo fc-cache -f -v;

# Install OSX cursors
tar -xjf 175749-OSX-ElCap.tar.bz2 \
 && cd OSX-ElCap && sudo ./install.sh \
 && cd - && rm -rf OSX-ElCap

# Install autokey
AUTOKEY_VERSION=$(curl -s https://api.github.com/repos/autokey/autokey/releases/latest | jq -r ".tag_name" | tr -d 'v')
wget https://github.com/autokey/autokey/releases/download/v${AUTOKEY_VERSION}/autokey-common_${AUTOKEY_VERSION}-0_all.deb \
 && wget https://github.com/autokey/autokey/releases/download/v${AUTOKEY_VERSION}/autokey-gtk_${AUTOKEY_VERSION}-0_all.deb \
 && sudo dpkg --install autokey-*.deb || true \
 && sudo apt --fix-broken install -y \
 && rm -rf autokey-*.deb \
 && mkdir -p ~/.config && cp -r autokey ~/.config/

install_extension() {
    EXT_PATH="extensions/$1"
    UUID=$(unzip -c $EXT_PATH.zip metadata.json | grep uuid | cut -d \" -f4)
    mkdir -p ~/.local/share/gnome-shell/extensions/$UUID
    unzip -q "$EXT_PATH.zip" -d ~/.local/share/gnome-shell/extensions/$UUID/
    gnome-shell-extension-tool -e $UUID
}

mkdir -p ~/.local/share/gnome-shell/extensions

install_extension "user-theme@gnome-shell-extensions.gcampax.github.com.v34.shell-extension"
install_extension "dash-to-dockmicxgx.gmail.com.v65.shell-extension"
install_extension "activities-confignls1729.v71.shell-extension"
install_extension "gnome-shell-aggressive-gc"
install_extension "gnomeGlobalAppMenu"

# Install gnome-global-app-menu
mkdir -p ~/.cinnamon-gnome/configs/gnomeGlobalAppMenu@lestcape
cp ./gnomeGlobalAppMenu@lestcape.json ~/.cinnamon-gnome/configs/gnomeGlobalAppMenu@lestcape/

sudo apt install -y ./GitHubDesktop-linux-2.0.4-linux1.deb
