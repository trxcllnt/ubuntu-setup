#!/usr/bin/env bash

set -e
set -o errexit

export DEBIAN_FRONTEND=noninteractive

# Prerequisites
# Install git from ppa
# Install git-lfs from universe
sudo apt update \
 && sudo apt upgrade --fix-missing -y \
 && sudo apt install -y \
    jq curl zlib1g-dev libssl-dev libcurl4-openssl-dev qt5-default exfat-utils \
    apt-transport-https ca-certificates gnupg-agent software-properties-common \
 && sudo add-apt-repository -y ppa:git-core/ppa && sudo apt update \
 && sudo apt install -y git git-lfs \
 && sudo apt autoremove -y

# Install latest CUDA and NVIDIA drivers
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt update && sudo apt -y install cuda
