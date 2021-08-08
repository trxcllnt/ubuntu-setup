#!/usr/bin/env bash

set -e
set -o errexit

export DEBIAN_FRONTEND=noninteractive

git clone https://github.com/trxcllnt/ubuntu-setup.git /tmp/ubuntu-setup \
 && cd /tmp/ubuntu-setup \
 && git lfs pull

./scripts/01-cuda.sh   || exit $?; source ~/.bashrc || exit $?;
./scripts/02-utils.sh  || exit $?; source ~/.bashrc || exit $?;
./scripts/03-docker.sh || exit $?; source ~/.bashrc || exit $?;
./scripts/04-cmake.sh  || exit $?; source ~/.bashrc || exit $?;
./scripts/05-node.sh   || exit $?; source ~/.bashrc || exit $?;
./scripts/06-vscode.sh || exit $?; source ~/.bashrc || exit $?;
./scripts/07-slack.sh  || exit $?; source ~/.bashrc || exit $?;
./scripts/08-xfce.sh   || exit $?; source ~/.bashrc || exit $?;
