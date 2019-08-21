# Make an NVIDIA-powered Ubuntu 18.04.2 fresh install look and feel a bit more like MacOS

This is the process I go through to set up a fresh Ubuntu 18.04.2 install. This repo describes how to install the various plugins,applications, configurations, and key bindings to make your Ubuntu install look and feel more like MacOS.

![Ubuntu 18.04.2 Gnome Screenshot](https://raw.githubusercontent.com/trxcllnt/ubuntu-setup/master/images/screenshot.png)

I've left off extra apps I install like chrome, vscode, docker, docker-compose, nvidia-docker etc.

#### Disclaimer: these instructions were typed half by hand from memory. Be sure to double check before hitting run in case I typo'd

### Install NVIDIA drivers + cuda
* Open NVIDIA's [CUDA Toolkit download page](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=debnetwork)
* Download the `.deb` file to `~/Downloads`
```shell
cd ~/Downloads \
&& sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub \
&& sudo dpkg -i cuda-repo-ubuntu1804_10.1.168-1_amd64.deb \
&& sudo apt update && sudo apt install cuda
```

## Reboot!

### Install the openconnect VPN UI
```shell
sudo apt install network-manager-openconnect-gnome
```

### Install [Gnome Shell Extensions](https://extensions.gnome.org/) integration

1. Install the [GNOME Shell integration](https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep) Chrome extension.
2. Install the Chrome integration package so you can install Gnome extensions via the browser, `gnome-tweak-tool` so you can turn extensions on and off, and `dconf-editor` so you can tweak individual things.
  ```shell
  sudo apt install chrome-gnome-shell gnome-tweak-tool dconf-editor
  ```

### Install Gnome Shell Extensions that will help us make Gnome look more like MacOS
* [User Themes](https://extensions.gnome.org/extension/19/user-themes/) applies your theme to all native gnome-shell applications (file browser, terminal emulator, OS settings, etc.)
* [Activity Configurator](https://extensions.gnome.org/extension/358/activities-configurator/) cleans up the top panel.
* [Dash-to-dock](https://extensions.gnome.org/extension/307/dash-to-dock/) makes the left Gnome Shell "dash" bar look and feel like the MacOS Dock.
* [Gnome GlobalAppMenu](https://extensions.gnome.org/extension/1250/gnome-global-application-menu/) moves app menus into the Gnome panel at the top. This project was abandoned by its author but still works great on Ubuntu 18.04.2.
    ```shell
    sudo apt install appmenu-gtk3-module
    mkdir -p ~/.local/share/gnome-shell/extensions
    unzip gnomeGlobalAppMenu@lestcape.zip -d ~/.local/share/gnome-shell/extensions
    ```

Now open Gnome Tweak Tool and enable all the extensions. Some of them won't activate until a reboot, which we'll do a bit later.

### Make Gnome look like MacOS
* Install Mac fonts
    ```shell
    sudo unzip mac-fonts.zip -d /usr/share/fonts;
    sudo fc-cache -f -v
    ```
* Install OS X [cursors](https://www.gnome-look.org/p/1084939/)
    ```shell
    tar -xvjf 175749-OSX-ElCap.tar.bz2
    cd OSX-ElCap && sudo ./install.sh && cd -
    ```
* Install [High Sierra theme](https://github.com/vinceliuice/Sierra-gtk-theme).
  Note: recently some styles were added that [broke the Gnome Global AppMenu](https://github.com/vinceliuice/Sierra-gtk-theme/issues/42), so I've pinned it to a working commit for this setup as a submodule.
    ```shell
    git submodule update --init --remote --recursive
    cd Sierra-gtk-theme && sudo ./install.sh -g -na && cd -
    ```

### Make Gnome behave like MacOS
* Rebind Alt -> Cmd via [Autokey](https://github.com/autokey/autokey)
    ```shell
    sudo apt install autokey-gtk
    mkdir -p ~/.config && cp -r autokey ~/.config/
    ```

## Reboot!

Now run `gnome-tweaks` in terminal (or open `Tweaks` in Ubuntu's App launcher) and verify all your extensions are on. If they're not, toggle them on and reboot again.

Once they're all toggled on, we need to fix some things about the `Gnome Global AppMenu`:
* Open the file at `./gnomeGlobalAppMenu@lestcape.json` in this repository
* Open the file at `~/.cinnamon-gnome/configs/gnomeGlobalAppMenu@lestcape/gnomeGlobalAppMenu@lestcape.json`
* Copy and paste the contents of `./gnomeGlobalAppMenu@lestcape.json` into your version under `~/.cinnamon-gnome`, _**with the exception of**_ the last five or six lines that look like this:
```json
    "dbusmenu-providers": {
        "type": "generic",
        "default": "",
        "value": "73400321-X11RegisterMenuWatcher,:1.109,/com/canonical/menu/4600001;73400387-X11RegisterMenuWatcher,:1.109,/com/canonical/menu/4600043;73400402-X11RegisterMenuWatcher,:1.109,/com/canonical/menu/4600052;96468993-X11RegisterMenuWatcher,:1.121,/com/canonical/menu/5C00001;96469608-X11RegisterMenuWatcher,:1.121,/com/canonical/menu/5C00268;3-GtkMenuWatcher,:1.160,/org/gnome/Terminal/menus/menubar,/org/gnome/Terminal/window/1,/org/gnome/Terminal;7-GtkMenuWatcher,:1.248,/org/appmenu/gtk/window/2,/org/gnome/Nautilus/window/2,/org/gnome/Nautilus;8-GtkMenuWatcher,:1.248,/org/appmenu/gtk/window/10,/org/gnome/Nautilus/window/3,/org/gnome/Nautilus;9-GtkMenuWatcher,:1.248,/org/appmenu/gtk/window/13,/org/gnome/Nautilus/window/4,/org/gnome/Nautilus;10-GtkMenuWatcher,:1.248,/org/appmenu/gtk/window/19,null,null;"
    },
    "__md5__": "799d4f590ba75108a7ac9207c0918120"
```

**Leave those lines above, don't replace those lines in your local version!**

## Reboot!

After logging in again, load the rest of the dconf settings:
```
dconf load / < dconf-settings.ini
```

This will automatically set your system cursors, icons, fonts, themes, and extension settings. Everything should update all at once.

## Reboot!

## Extra goodies

### Slack Dark Mode
* First install [Slack Desktop for Linux](https://slack.com/intl/de-de/downloads/linux)
* Then run this (_must_ be in the `slack` directory):
    ```shell
    cd slack && sudo ./install-slack-black-theme.sh
    ```

### Github Desktop (with native menubars)
There was a recent commit that made GH Desktop use windows metro style titlebar/icons. If you're fine with that, great. If not, you can install an older release, or [use docker to build the latest source locally](https://github.com/shiftkey/desktop/issues/149).

### Ultrawide Wallpaper
I have a [49" Samsung C49RG9](https://www.samsung.com/levant/monitors/c49rg9/) monitor with a 5120x1440 native resolution. It's difficult to find dark-mode-compatible wallpapers this large, but I've included mine in the images folder.

Since X still doesn't support separate wallpapers on each monitor (and the two most popular solutions didn't work for me), I've included a version that extends the image out with a black background to cover my laptop's background. This way you can use the Gnome Tweak Tool to set the wallpaper mode to "span" so the image isn't scaled.
