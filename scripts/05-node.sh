#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

# Install nvm and node
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node
npm completion | sudo tee /etc/bash_completion.d/npm >/dev/null

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
optional=false
loglevel=error
save-exact=true
package-lock=false
update-notifier=false
scripts-prepend-node-path=true
registry=https://registry.npmjs.org/
' > ~/.npmrc

source ~/.bashrc

# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y --no-install-recommends yarn

# Install yarn completions
curl -fsSL --compressed \
    https://raw.githubusercontent.com/dsifford/yarn-completion/5bf2968493a7a76649606595cfca880a77e6ac0e/yarn-completion.bash \
  | sudo tee /etc/bash_completion.d/yarn >/dev/null

echo '
disable-self-update-check true
registry "https://registry.npmjs.org/"

--add.silent true
--install.silent true

--add.strict-semver true
--install.strict-semver true

--add.ignore-engines true
--install.ignore-engines true

--add.scripts-prepend-node-path true
--run.scripts-prepend-node-path true
--install.scripts-prepend-node-path true
' > ~/.yarnrc
