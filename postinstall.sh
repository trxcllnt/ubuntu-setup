#!/usr/bin/env bash

set -e
set -o errexit

export DEBIAN_FRONTEND=noninteractive

sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-9.2 0
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.0 0
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.1 0
sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.2 100

bash -i ./scripts/02-utils.sh && source ~/.bashrc
bash -i ./scripts/03-docker.sh && source ~/.bashrc
bash -i ./scripts/04-cmake.sh && source ~/.bashrc
bash -i ./scripts/05-node.sh && source ~/.bashrc
bash -i ./scripts/06-vscode.sh && source ~/.bashrc
bash -i ./scripts/07-slack.sh && source ~/.bashrc
bash -i ./scripts/08-xfce.sh && source ~/.bashrc
