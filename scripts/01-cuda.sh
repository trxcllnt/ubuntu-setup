#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

# CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
sudo apt update && sudo apt -y install cuda

mkdir -p ~/.config \
 && cp monitors.xml ~/.config \
 && sudo mkdir -p /var/lib/gdm3/.config/ \
 && sudo cp monitors.xml /var/lib/gdm3/.config/monitors.xml

echo -e '
options nvidia-drm modeset=1 
options nvidia NVreg_EnablePCIeGen3=1
options nvidia NVreg_UsePageAttributeTable=1
' | sudo tee /etc/modprobe.d/nvidia.conf

