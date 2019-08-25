#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

# CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository -y "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
sudo apt update && sudo apt -y install cuda

cur_screen_x=$(xrandr --current 2>/dev/null | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
cur_screen_y=$(xrandr --current 2>/dev/null | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)
cur_screen_r=$(xrandr --current 2>/dev/null | grep '*' | uniq | awk '{print $2}' | cut -d '*' -f1)

mkdir -p ~/.config && sudo mkdir -p ~gdm/.config/ && cat monitors.xml \
 | sed s/5120/$cur_screen_x/ \
 | sed s/1440/$cur_screen_y/ \
 | sed s/119.97019195556641/$cur_screen_r/ > ~/.config/monitors.xml \
 && chmod 755 ~/.config/monitors.xml \
 && sudo cp ~/.config/monitors.xml ~gdm/.config/monitors.xml \
 && sudo chown gdm:gdm ~gdm/.config/monitors.xml

# These kernel module settings help boost performance
echo -e 'options nvidia-drm modeset=1
options nvidia NVreg_EnablePCIeGen3=1
options nvidia NVreg_UsePageAttributeTable=1' | sudo tee -a /etc/modprobe.d/nvidia.conf

# Blacklist nouveau
echo -e 'blacklist nouveau
options nouveau modeset=0' | sudo tee -a /etc/modprobe.d/nvidia-graphics-drivers.conf

sudo update-initramfs -u
