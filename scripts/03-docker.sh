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

# Install docker compose v2
sudo mkdir -p /usr/local/lib/docker/cli-plugins
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r ".tag_name" | tr -d 'v')
sudo curl \
    -L https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m) \
    -o /usr/local/lib/docker/cli-plugins/docker-compose && sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Install compose-switch (backwards compat for docker-compose)
DOCKER_COMPOSE_SWITCH_VERSION=$(curl -s https://api.github.com/repos/docker/compose-switch/releases/latest | jq -r ".tag_name" | tr -d 'v')
sudo curl \
    -L https://github.com/docker/compose-switch/releases/download/v$DOCKER_COMPOSE_SWITCH_VERSION/docker-compose-$(uname -s)-$(dpkg-architecture -q DEB_BUILD_ARCH) \
    -o /usr/local/bin/compose-switch && sudo chmod +x /usr/local/bin/compose-switch

sudo update-alternatives --install /usr/local/bin/docker-compose docker-compose /usr/local/bin/compose-switch 99

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
