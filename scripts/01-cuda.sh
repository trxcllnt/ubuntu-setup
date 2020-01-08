#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

# CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository -y "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
sudo apt update && sudo apt -y install cuda

# Install cuda-toolkit 9.2
wget https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux
sudo sh cuda_9.2.148_396.37_linux --toolkit --toolkitpath=/usr/local/cuda-9.2 --silent --override
rm -rf cuda_9.2.148_396.37_linux

if [ ! -d /usr/local/cuda-9.2/targets/x86_64-linux ]; then
    sudo mkdir -p /usr/local/cuda-9.2/targets/x86_64-linux
    sudo ln -s /usr/local/cuda-9.2/include /usr/local/cuda-9.2/targets/x86_64-linux/include
fi

# Install cuda-toolkit 10.0
wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux
sudo sh cuda_10.0.130_410.48_linux --toolkit --toolkitpath=/usr/local/cuda-10.0 --silent --override
rm -rf cuda_10.0.130_410.48_linux

if [ ! -d /usr/local/cuda-10.0/targets/x86_64-linux ]; then
    sudo mkdir -p /usr/local/cuda-10.0/targets/x86_64-linux
    sudo ln -s /usr/local/cuda-10.0/include /usr/local/cuda-10.0/targets/x86_64-linux/include
fi


# Install cuda-toolkit 10.1
wget https://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.243_418.87.00_linux.run
sudo sh cuda_10.1.243_418.87.00_linux.run --toolkit --toolkitpath=/usr/local/cuda-10.1 --silent --override
rm -rf cuda_10.1.243_418.87.00_linux.run

if [ ! -d /usr/local/cuda-10.1/targets/x86_64-linux ]; then
    sudo mkdir -p /usr/local/cuda-10.1/targets/x86_64-linux
    sudo ln -s /usr/local/cuda-10.1/include /usr/local/cuda-10.1/targets/x86_64-linux/include
fi

