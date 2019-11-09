#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

# CMake
CMAKE_VERSION=$(curl -s https://api.github.com/repos/Kitware/CMake/releases/latest | jq -r ".tag_name" | tr -d 'v')
wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz \
 && tar -xvzf cmake-${CMAKE_VERSION}.tar.gz && cd cmake-${CMAKE_VERSION} \
 && ./bootstrap --qt-gui --system-curl --parallel=$(nproc) && sudo make install -j \
 && cd - && rm -rf ./cmake-${CMAKE_VERSION} ./cmake-${CMAKE_VERSION}.tar.gz
