#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

# Install docker-ce
release=$(lsb_release -cs) \
 && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
 && sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $release stable" \
 && sudo apt install -y docker-ce \
 && sudo usermod -aG docker $USER

# Install docker-compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r ".tag_name" | tr -d 'v')
sudo curl \
    -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` \
    -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose

# Install compose-cli and docker compose v2
curl -L https://raw.githubusercontent.com/docker/compose-cli/main/scripts/install/install_linux.sh | sh \
 && mkdir -p ~/.docker/cli-plugins/ \
 && DOCKER_COMPOSE_CLI_VERSION=2.0.0-rc.2 \
 && _ARCH=$(dpkg-architecture -q DEB_BUILD_ARCH) \
 && _ARCH_OS=$(dpkg-architecture -q DEB_BUILD_ARCH_OS) \
 && curl \
    -L https://github.com/docker/compose-cli/releases/download/v$DOCKER_COMPOSE_CLI_VERSION/docker-compose-$_ARCH_OS-$_ARCH \
    -o ~/.docker/cli-plugins/docker-compose \
 && chmod +x ~/.docker/cli-plugins/docker-compose \
 && docker compose version

# Install nvidia-docker2
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
 && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
 && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list \
 && sudo apt update && sudo apt install -y nvidia-docker2

echo '{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}' | sudo tee /etc/docker/daemon.json
