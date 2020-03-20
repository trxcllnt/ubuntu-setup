#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

# Install gcc 7 and 8
sudo apt install gcc-7 g++-7 gcc-8 g++-8

# Use Ubuntu's update-alternatives utility to switch between GCC versions
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 0
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 0
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 0
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 0
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 100

# Make gcc-7 the default while we install the older CUDA toolkits
sudo update-alternatives --set gcc /usr/bin/gcc-7
sudo update-alternatives --set g++ /usr/bin/g++-7

# Install cuda-toolkit 9.2
wget -O cuda_9.2.run \
    https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux
sudo sh cuda_9.2.run --toolkit --toolkitpath=/usr/local/cuda-9.2 --silent
rm -rf cuda_9.2.run

if [ ! -d /usr/local/cuda-9.2/targets/x86_64-linux ]; then
    sudo mkdir -p /usr/local/cuda-9.2/targets/x86_64-linux
    sudo ln -s /usr/local/cuda-9.2/include /usr/local/cuda-9.2/targets/x86_64-linux/include
fi

# Install cuda-toolkit 10.0
wget -O cuda_10.0.run \
    https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux
sudo sh cuda_10.0.run --toolkit --toolkitpath=/usr/local/cuda-10.0 --silent
rm -rf cuda_10.0.run

if [ ! -d /usr/local/cuda-10.0/targets/x86_64-linux ]; then
    sudo mkdir -p /usr/local/cuda-10.0/targets/x86_64-linux
    sudo ln -s /usr/local/cuda-10.0/include /usr/local/cuda-10.0/targets/x86_64-linux/include
fi

# Install cuda-toolkit 10.1
wget -O cuda_10.1.run \
    https://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.243_418.87.00_linux.run
sudo sh cuda_10.1.run --toolkit --toolkitpath=/usr/local/cuda-10.1 --silent
rm -rf cuda_10.1.run

if [ ! -d /usr/local/cuda-10.1/targets/x86_64-linux ]; then
    sudo mkdir -p /usr/local/cuda-10.1/targets/x86_64-linux
    sudo ln -s /usr/local/cuda-10.1/include /usr/local/cuda-10.1/targets/x86_64-linux/include
fi

# Install update-alternatives for each CUDA version
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-9.2 0
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.0 0
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.1 0
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.2 100

[ ! "$(grep CUDA_HOME ~/.bashrc)" ] && echo '
export CUDA_HOME="/usr/local/cuda"
export PATH="$PATH:$CUDA_HOME/bin"
' >> ~/.bashrc;

# Set gcc-9 back as the default
sudo update-alternatives --set gcc /usr/bin/gcc-9
sudo update-alternatives --set g++ /usr/bin/g++-9
