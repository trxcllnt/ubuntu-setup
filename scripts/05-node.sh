#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

# Install nvm and node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && exec $SHELL

nvm install node
npm completion | sudo tee /etc/bash_completion.d/npm

echo -e '
NODE_BIN="$(nvm which current)"
export NODE_BIN_PATH="$(dirname $NODE_BIN)"
export NODE_HOME="$(cd $NODE_BIN_PATH/../;pwd)"
export NODE_INCLUDE_PATH="$NODE_HOME/include/node"
' >> ~/.bashrc

# node-3d dependencies
sudo add-apt-repository -y "deb http://security.ubuntu.com/ubuntu xenial-security main" \
 && sudo apt install -y bear libjasper1 libjasper-dev \
 && sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 100
