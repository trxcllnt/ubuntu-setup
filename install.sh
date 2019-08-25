#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Prerequisites
sudo apt update \
 && sudo apt upgrade --fix-missing -y \
 && sudo apt install -y \
    curl zlib1g-dev libssl-dev libcurl4-openssl-dev qt5-default \
    apt-transport-https ca-certificates gnupg-agent software-properties-common \
 && sudo apt autoremove -y

bash -i ./scripts/01-cuda.sh
bash -i ./scripts/02-utils.sh
bash -i ./scripts/03-docker.sh
bash -i ./scripts/04-cmake.sh
bash -i ./scripts/05-node.sh
bash -i ./scripts/06-vscode.sh
bash -i ./scripts/07-slack.sh
bash -i ./scripts/08-gnome-shell.sh
