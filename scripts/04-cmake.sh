#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

# Install kitware CMake apt sources
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
  | gpg --dearmor - \
  | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

echo -e "\
deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main\n\
" | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null

# Install CMake
sudo apt update && sudo apt install --no-install-recommends -y cmake
