#!/usr/bin/env bash

set -e
set -o errexit

export DEBIAN_FRONTEND=noninteractive

# Prerequisites
sudo apt update \
 && sudo apt upgrade --fix-missing -y \
 && sudo apt install -y \
    curl zlib1g-dev libssl-dev libcurl4-openssl-dev qt5-default \
    apt-transport-https ca-certificates gnupg-agent software-properties-common \
 && sudo apt autoremove -y

bash -i ./scripts/01-cuda.sh && source ~/.bashrc
