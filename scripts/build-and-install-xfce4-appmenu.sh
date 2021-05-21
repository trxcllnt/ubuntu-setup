#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

# Install vala-panel-appmenu build dependencies
# https://gitlab.com/vala-panel-project/vala-panel-appmenu
sudo apt install -y \
    bamfdaemon libdbusmenu-glib-dev \
    libgtk2.0-dev gobject-introspection libbamf3-dev \
    libdbus-glib-1-dev libffi-dev libgirepository1.0-dev \
    libpeas-dev libstartup-notification0-dev libwnck-3-dev \
    libwnck-common libwnck22 libxml2-utils libxres-dev \
    libvala-0.48-0 libvala-0.48-dev valac valac-0.48-vapi \
    meson \
    exo-utils libexo-1-0 libexo-2-0 libexo-common libexo-helpers \
    libgarcon-1-0 libgarcon-common \
    libxfce4panel-2.0-4 libxfce4panel-2.0-dev \
    libxfce4ui-1-0 libxfce4ui-2-0 libxfce4ui-common \
    libxfce4util7 libxfce4util-common libxfce4util-dev \
    libxfconf-0-3 libxfconf-0-dev \
    xfce4-panel xfce4-panel-dev \
    xfconf \
    unity-gtk-module-common unity-gtk2-module unity-gtk3-module

git clone https://gitlab.com/vala-panel-project/vala-panel-appmenu.git /tmp/vala-panel-appmenu

mkdir -p /tmp/vala-panel-appmenu/build
cd /tmp/vala-panel-appmenu
meson --prefix=/usr \
    -Dxfce=enabled \
    -Dmate=disabled \
    -Dbudgie=disabled \
    -Djayatana=disabled \
    -Dvalapanel=disabled \
    -Dappmenu-gtk-module=disabled \
    /tmp/vala-panel-appmenu/build

ninja -C /tmp/vala-panel-appmenu/build
sudo ninja -C /tmp/vala-panel-appmenu/build install

# https://gitlab.com/vala-panel-project/vala-panel-appmenu#desktop-environment-specific-settings
xfconf-query -c xsettings -p /Gtk/ShellShowsMenubar -n -t bool -s true
xfconf-query -c xsettings -p /Gtk/ShellShowsAppmenu -n -t bool -s true

# https://github.com/rilian-la-te/vala-panel-appmenu/blob/master/subprojects/appmenu-gtk-module/README.md#usage-instructions
xfconf-query -c xsettings -p /Gtk/Modules -n -t string -s "unity-gtk-module"
