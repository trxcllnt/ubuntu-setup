#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Prerequisites
sudo apt update \
 && sudo apt upgrade --fix-missing -y \
 && sudo apt install \
    curl zlib1g-dev libssl-dev libcurl4-openssl-dev qt5-default \
    apt-transport-https ca-certificates gnupg-agent software-properties-common

./scripts/01-cuda.sh
./scripts/02-utils.sh
./scripts/03-docker.sh
./scripts/04-cmake.sh
./scripts/05-node.sh
./scripts/06-vscode.sh
./scripts/07-slack.sh
./scripts/08-gnome-shell.sh
