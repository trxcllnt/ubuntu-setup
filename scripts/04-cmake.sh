#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

CMAKE_VERSION="3.15.2"

# CMake
wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz \
 && tar -xvzf cmake-${CMAKE_VERSION}.tar.gz && cd cmake-${CMAKE_VERSION} \
 && ./bootstrap --qt-gui --system-curl --parallel=$(nproc) && sudo make install -j \
 && cd - && rm -rf ./cmake-${CMAKE_VERSION} ./cmake-${CMAKE_VERSION}.tar.gz
