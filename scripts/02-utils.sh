#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

trap 'ERRCODE=$? \
  && rm -rf ./fd_*.deb ./bat_*.deb ./hub-linux-amd64-* \
  && exit $ERRCODE' \
  ERR EXIT

# Install google chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update && sudo apt install -y google-chrome-stable

# Install github cli
GITHUB_VERSION=$(curl -s https://api.github.com/repos/github/hub/releases/latest | jq -r ".tag_name" | tr -d 'v')
curl -o ./hub-linux-amd64-${GITHUB_VERSION}.tgz \
     -L https://github.com/github/hub/releases/download/v${GITHUB_VERSION}/hub-linux-amd64-${GITHUB_VERSION}.tgz
tar -xvzf hub-linux-amd64-${GITHUB_VERSION}.tgz
sudo ./hub-linux-amd64-${GITHUB_VERSION}/install
sudo mv ./hub-linux-amd64-${GITHUB_VERSION}/etc/hub.bash_completion.sh /etc/bash_completion.d/hub

# Install fd
FD_VERSION=$(curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | jq -r ".tag_name" | tr -d 'v')
wget https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd_${FD_VERSION}_amd64.deb
sudo dpkg -i fd_*.deb

# Install bat
BAT_VERSION=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq -r ".tag_name" | tr -d 'v')
wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb
sudo dpkg -i bat_*.deb

# Add a `disk-usage` bash alias for printing and sorting file size stats
touch ~/.bash_aliases
if [ ! "$(grep disk-usage ~/.bash_aliases)" ]; then
    echo '
disk-usage() {
    du -Sh ${1:-.} | sort -rh | head "${@:2}"
}
export -f disk-usage;
' >> ~/.bash_aliases
fi

# Install fzf
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
    echo '
# Set fd as the default source for fzf
# Follow symbolic links, search hidden files, exclude gitignored files
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER="~~"

# Options to fzf command
export FZF_COMPLETION_OPTS="+c -x"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> ~/.bash_aliases;
fi
