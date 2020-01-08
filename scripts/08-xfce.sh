#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

mkdir -p ~/Pictures && cp images/*.jpeg ~/Pictures/

sudo apt install -y \
    xfce4-appmenu-plugin \
    network-manager-openconnect

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

# Install Github Desktop
sudo apt install -y ./GitHubDesktop-linux-2.0.4-linux1.deb

# Restore xfce settings
tar -xzvf .config.tar.gz -C ~/.config/
