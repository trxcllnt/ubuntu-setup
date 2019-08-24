#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

GITHUB_VERSION="2.12.3"

# Install git from ppa
sudo add-apt-repository -y ppa:git-core/ppa \
 && sudo apt install -y git

# Install github cli
curl -o ./hub-linux-amd64-${GITHUB_VERSION}.tgz \
     -L https://github.com/github/hub/releases/download/v${GITHUB_VERSION}/hub-linux-amd64-${GITHUB_VERSION}.tgz \
 && tar -xvzf hub-linux-amd64-${GITHUB_VERSION}.tgz \
 && cd hub-linux-amd64-${GITHUB_VERSION} \
 && sudo ./install \
 && sudo mv ./etc/hub.bash_completion.sh /etc/bash_completion.d/hub \
 && cd - && rm -rf ./hub-linux-amd64-${GITHUB_VERSION} ./hub-linux-amd64-${GITHUB_VERSION}.tgz
