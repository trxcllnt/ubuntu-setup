#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

# Slack desktop
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.2-amd64.deb \
 && sudo apt install ./slack-desktop-*.deb \
 && rm -rf ./slack-desktop-*.deb

cd slack-black-theme && bash ./darkSlack.sh || true && cd -
