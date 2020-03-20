#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

mkdir -p ~/Pictures && cp images/*.jpeg ~/Pictures/

sudo apt install -y \
    xfce4-appmenu-plugin \
    network-manager-openconnect-gnome

# Install sierra-gtk-theme and plank
echo "deb http://ppa.launchpad.net/ricotz/docky/ubuntu eoan main
# deb-src http://ppa.launchpad.net/ricotz/docky/ubuntu eoan main
" | sudo tee /etc/apt/sources.list.d/ricotz-ubuntu-docky-eoan.list \
 && \
echo "deb http://ppa.launchpad.net/dyatlov-igor/sierra-theme/ubuntu bionic main
# deb-src http://ppa.launchpad.net/dyatlov-igor/sierra-theme/ubuntu bionic main
" | sudo tee /etc/apt/sources.list.d/dyatlov-igor-ubuntu-sierra-theme-bionic.list \
 && sudo apt update && sudo apt install -y plank sierra-gtk-theme-git

# Install fonts
sudo unzip -q theme/fonts.zip -d /usr/share/fonts; sudo fc-cache -f -v;

# Install cursors
tar -xjf theme/cursors.tar.bz2 \
 && sudo cp -rf OSX-ElCap/ /usr/share/icons/OSX-ElCap \
 && sudo update-alternatives --install \
    /usr/share/icons/default/index.theme \
    x-cursor-theme \
    /usr/share/icons/OSX-ElCap/cursor.theme 90 \
 && rm -rf OSX-ElCap

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
