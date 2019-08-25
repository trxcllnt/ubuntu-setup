#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

FD_VERSION="7.3.0"
BAT_VERSION="0.11.0"
GITHUB_VERSION="2.12.3"

# Install git from ppa
sudo add-apt-repository -y ppa:git-core/ppa && sudo apt install -y git

# Install github cli
curl -o ./hub-linux-amd64-${GITHUB_VERSION}.tgz \
     -L https://github.com/github/hub/releases/download/v${GITHUB_VERSION}/hub-linux-amd64-${GITHUB_VERSION}.tgz \
 && tar -xvzf hub-linux-amd64-${GITHUB_VERSION}.tgz \
 && cd hub-linux-amd64-${GITHUB_VERSION} \
 && sudo ./install \
 && sudo mv ./etc/hub.bash_completion.sh /etc/bash_completion.d/hub \
 && cd - && rm -rf ./hub-linux-amd64-${GITHUB_VERSION} ./hub-linux-amd64-${GITHUB_VERSION}.tgz

# Install fd
wget https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd_${FD_VERSION}_amd64.deb \
 && sudo dpkg -i fd_*.deb && rm -rf fd_*.deb

# Install bat
wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb \
 && sudo dpkg -i bat_*.deb && rm -rf bat_*.deb

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
echo -e 'alias fd=fdfind

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

[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> ~/.bashrc
