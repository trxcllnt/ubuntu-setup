#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

mkdir -p ~/Pictures && cp images/*.jpeg ~/Pictures/

sudo apt install -y network-manager-openconnect-gnome

# Install sierra-gtk-theme and plank
sudo add-apt-repository -y ppa:ricotz/docky || true
sudo add-apt-repository -y ppa:dyatlov-igor/sierra-theme || true
sudo rm /etc/apt/sources.list.d/ricotz-ubuntu-docky-*.list
sudo rm /etc/apt/sources.list.d/dyatlov-igor-ubuntu-sierra-theme-*.list

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
 && sudo cp -rf OSX-ElCap/OSX-ElCap/ /usr/share/icons/OSX-ElCap \
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

# Install Github Desktop
# GITHUB_DESKTOP_URL=$(curl -s https://api.github.com/repos/shiftkey/desktop/releases | jq -r ".[0].assets[].browser_download_url" | grep ".deb" | head -n1)
# wget -q -O GitHubDesktop.deb "$GITHUB_DESKTOP_URL" \
#   && sudo apt install -y ./GitHubDesktop.deb \
#   && rm -rf ./GitHubDesktop.deb

# Restore xfce settings
tar -xzvf .config.tar.gz -C ~/

# Build and install the xfce4-appmenu-plugin from source
source ./scripts/build-and-install-xfce4-appmenu.sh
