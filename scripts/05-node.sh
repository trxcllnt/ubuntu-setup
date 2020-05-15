#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

# Install nvm and node
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node
npm completion | sudo tee /etc/bash_completion.d/npm

if [ ! "$(grep NODE_BIN_PATH ~/.bashrc)" ]; then
    echo '
NODE_BIN="$(nvm which current)"
export NODE_NO_WARNINGS=1
export NODE_PENDING_DEPRECATION=0
export NODE_BIN_PATH="$(dirname $NODE_BIN)"
export NODE_HOME="$(cd $NODE_BIN_PATH/../;pwd)"
export NODE_INCLUDE_PATH="$NODE_HOME/include/node"
' >> ~/.bashrc
fi

echo '
fund=false
save-prefix=
package-lock=false
update-notifier=false
' > ~/.npmrc

source ~/.bashrc

# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y --no-install-recommends yarn
