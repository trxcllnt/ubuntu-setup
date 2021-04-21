#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

# Install gcc 7, 8, 9, and 10
sudo apt install -y gcc-7 g++-7 gcc-8 g++-8 gcc-9 g++-9 gcc-10 g++-10

# Remove any existing gcc and g++ alternatives 
sudo update-alternatives --remove-all cc  >/dev/null 2>&1 || true
sudo update-alternatives --remove-all c++ >/dev/null 2>&1 || true
sudo update-alternatives --remove-all gcc >/dev/null 2>&1 || true
sudo update-alternatives --remove-all g++ >/dev/null 2>&1 || true

# Use Ubuntu's update-alternatives utility to switch between GCC versions
for x in 7 8 9 10; do
    sudo update-alternatives \
        --install /usr/bin/gcc gcc /usr/bin/gcc-$x ${x}0 \
        --slave /usr/bin/cc cc /usr/bin/gcc-$x \
        --slave /usr/bin/g++ g++ /usr/bin/g++-$x \
        --slave /usr/bin/c++ c++ /usr/bin/g++-$x \
        --slave /usr/bin/gcov gcov /usr/bin/gcov-$x
done;

# Make gcc-7 the default while we install CUDA Toolkit 10.2
sudo update-alternatives --set gcc /usr/bin/gcc-7

# Install cuda-toolkit 10.2
wget -O /tmp/cuda_10.2.run \
    http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
sudo sh /tmp/cuda_10.2.run --toolkit --toolkitpath=/usr/local/cuda-10.2 --silent
rm -rf /tmp/cuda_10.2.run

if [ -d /usr/local/cuda-10.2/include ]; then
    if [ ! -d /usr/local/cuda-10.2/targets/x86_64-linux ]; then
        sudo mkdir -p /usr/local/cuda-10.2/targets/x86_64-linux
        sudo ln -s /usr/local/cuda-10.2/include /usr/local/cuda-10.2/targets/x86_64-linux/include
    fi
fi

# Make gcc-9 the default while we install CUDA Toolkit 11.x
sudo update-alternatives --set gcc /usr/bin/gcc-9

# Install cuda-toolkit 11.0
wget -O /tmp/cuda_11.0.run \
    https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda_11.0.3_450.51.06_linux.run
sudo sh /tmp/cuda_11.0.run --toolkit --toolkitpath=/usr/local/cuda-11.0 --silent
rm -rf /tmp/cuda_11.0.run

if [ -d /usr/local/cuda-11.0/include ]; then
    if [ ! -d /usr/local/cuda-11.0/targets/x86_64-linux ]; then
        sudo mkdir -p /usr/local/cuda-11.0/targets/x86_64-linux
        sudo ln -s /usr/local/cuda-11.0/include /usr/local/cuda-11.0/targets/x86_64-linux/include
    fi
fi

# Install cuda-toolkit 11.1
wget -O /tmp/cuda_11.1.run \
    https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda_11.1.1_455.32.00_linux.run
sudo sh /tmp/cuda_11.1.run --toolkit --toolkitpath=/usr/local/cuda-11.1 --silent
rm -rf /tmp/cuda_11.1.run

if [ -d /usr/local/cuda-11.1/include ]; then
    if [ ! -d /usr/local/cuda-11.1/targets/x86_64-linux ]; then
        sudo mkdir -p /usr/local/cuda-11.1/targets/x86_64-linux
        sudo ln -s /usr/local/cuda-11.1/include /usr/local/cuda-11.1/targets/x86_64-linux/include
    fi
fi

# Install cuda-toolkit 11.2
wget -O /tmp/cuda_11.2.run \
    https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda_11.2.2_460.32.03_linux.run
sudo sh /tmp/cuda_11.2.run --toolkit --toolkitpath=/usr/local/cuda-11.2 --silent
rm -rf /tmp/cuda_11.2.run

if [ -d /usr/local/cuda-11.2/include ]; then
    if [ ! -d /usr/local/cuda-11.2/targets/x86_64-linux ]; then
        sudo mkdir -p /usr/local/cuda-11.2/targets/x86_64-linux
        sudo ln -s /usr/local/cuda-11.2/include /usr/local/cuda-11.2/targets/x86_64-linux/include
    fi
fi

CURRENT_CUDA_VERSION="$(/usr/local/cuda/bin/nvcc --version | head -n4 | tail -n1 | cut -d' ' -f5 | cut -d',' -f1)"

# Install update-alternatives for each CUDA version
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.2 0
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-11.0 0
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-11.1 0
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-11.2 0
# set the latest apt-installed CUDA version as the highest priority
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-$CURRENT_CUDA_VERSION 100

if [ ! "$(grep CUDA_HOME ~/.bashrc)" ]; then
    echo '
export CUDA_HOME="/usr/local/cuda"
export PATH="$PATH:$CUDA_HOME/bin"
' >> ~/.bashrc;
fi

# Set gcc-9 as the default
sudo update-alternatives --set gcc /usr/bin/gcc-9
