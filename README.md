My setup scripts to bootstrap a new Ubuntu 18.04 install, making it look and feel a bit more like MacOS.

```shell
git clone --recurse-submodules https://github.com/trxcllnt/ubuntu-setup.git ~/ubuntu-setup

# Run this while still chroot'd into a fresh ubuntu install in the live USB
sudo bash ./preinstall.sh

# Run this on first boot after a fresh install
sudo bash ./postinstall.sh
```

![Ubuntu 18.04.3 Gnome Screenshot](https://raw.githubusercontent.com/trxcllnt/ubuntu-setup/master/images/screenshot.png)
