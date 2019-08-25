#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

AUTOKEY_VERSION="0.95.7"

cp images/*.jpeg ~/Pictures/

sudo apt install -y \
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
 && sudo dpkg --install autokey-*.deb || true \
 && sudo apt --fix-broken install -y \
 && rm -rf autokey-*.deb \
 && mkdir -p ~/.config && cp -r autokey ~/.config/
