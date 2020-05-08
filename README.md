My setup scripts to bootstrap a new Xubuntu 20.04 install, making it look and feel a bit more like MacOS.

![Xubuntu 20.04 Screenshot](https://media.githubusercontent.com/media/trxcllnt/ubuntu-setup/master/images/screenshot.png)


## Installation

Installation is broken up into two steps. The first step is run from the live CD/USB after the Xubuntu installer has finished. The second step is run immediately after first boot.

### Step 1: Install Xubuntu from live CD/USB

Install Xubuntu from a live USB. When the installer completes, it will show an alert box with options "Continue Testing", and "Restart Now".

_*Don't select either of these options.*_ Instead, move the alert box to the side, and open a terminal window. As long as the alert box is open, your new Xubuntu installation will still be mounted at `/target`.

Run `lsblk` in the terminal to verify this, as shown here:

![Step 1](https://media.githubusercontent.com/media/trxcllnt/ubuntu-setup/master/images/step-1.0.png)

If you don't see `/target/boot` and `/target/boot/efi` mount points, run these commands to mount them:

```shell
sudo mount /dev/nvme0n1p2 /target/boot
sudo mount /dev/nvme0n1p1 /target/boot/efi
```

Now, run this to chroot into your fresh Xubuntu installation from the live disk:

```shell
for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /target$i; done
sudo cp /etc/resolv.conf /target/etc/
sudo chroot /target
```

Once you've chroot'd into your Xubuntu installation, run the `pre-boot.sh` script:

```shell
# Run this while still chroot'd into a fresh ubuntu install in the live USB
wget -qO- https://raw.githubusercontent.com/trxcllnt/ubuntu-setup/master/pre-boot.sh | sudo bash
```

This script will install:
* [`jq`](https://stedolan.github.io/jq/)
* Latest `git` from the official PPA `ppa:git-core/ppa`
* A few prerequisite system dependencies (git-lfs, curl, zlib, qt-5, exfat-utils, etc.)
* The latest NVIDIA CUDA toolkit and drivers. This ensures you have a working GPU on your first boot.

Once this script is finished, exit your terminal and reboot.

### Step 2: Install everything else on first boot

After rebooting, you're ready to install everything else.

```shell
wget -qO- https://raw.githubusercontent.com/trxcllnt/ubuntu-setup/master/post-boot.sh | sudo bash
```

This script will install:
* Older CUDA toolkits and gcc-7/8 for development
* Basic apps and development utilities:
  * [Google Chrome](https://www.google.com/chrome/index.html)
  * [`github-cli`](https://github.com/github/hub)
  * [`fd`](https://github.com/sharkdp/fd)
  * [`bat`](https://github.com/sharkdp/fd)
  * [`fzf`](https://github.com/junegunn/fzf)
  * [`docker-ce`](https://docs.docker.com/install/linux/docker-ce/ubuntu/), [`docker-compose`](https://github.com/docker/compose), and [`nvidia-docker2`](https://github.com/NVIDIA/nvidia-docker)
  * [`cmake`](https://cmake.org/)
  * [`nvm`](https://github.com/nvm-sh/nvm), `node`, and [`yarn`](https://classic.yarnpkg.com/en/)
  * [VSCode](https://code.visualstudio.com/)
  * [Slack for Linux](https://slack.com/downloads/linux)
  * [Github Desktop for Linux](https://desktop.github.com/)
* XFCE-4 themes, plugins, keybindings, and settings:
  * `xfce4-appmenu-plugin`
  * `network-manager-openconnect-gnome`
  * `plank`
  * [Sierra GTK theme](https://github.com/vinceliuice/Sierra-gtk-theme)
  * [OSX El Capitan Cursors theme](https://www.gnome-look.org/content/show.php/OSX+El+Capitan?content=175749)
  * [`autokey-gtk`](https://github.com/autokey/autokey) and a set of MacOS-style key re-binding scripts

After this script is done, reboot one more time and you're all set!
