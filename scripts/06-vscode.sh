#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

# Install clangd and bear
# release=$(lsb_release -cs)
release="eoan"
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
echo "deb http://apt.llvm.org/$release/ llvm-toolchain-$release main
deb-src http://apt.llvm.org/$release/ llvm-toolchain-$release main
" | sudo tee /etc/apt/sources.list.d/llvm.list

sudo apt update && sudo apt install -y clangd bear

# Install vscode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ && rm packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update && sudo apt install -y code

# Install some useful vscode extensions
code --install-extension slevesque.shader
code --install-extension ms-python.python
code --install-extension eg2.vscode-npm-script
code --install-extension guyskk.language-cython
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension christian-kohler.npm-intellisense
code --install-extension ms-vscode.cpptools
code --install-extension kriegalex.vscode-cudacpp
code --install-extension llvm-vs-code-extensions.vscode-clangd

# Install vscode settings and keybindings
mkdir -p ~/.config/Code/User/ && cp vscode/*.json ~/.config/Code/User/

[ ! "$(grep SHELL_SESSION_HISTORY ~/.bashrc)" ] && echo '
export SHELL_SESSION_HISTORY=0
' >> ~/.bashrc;

[ ! "$(grep DOTNET_CLI_TELEMETRY_OPTOUT ~/.bashrc)" ] && echo '
export export DOTNET_CLI_TELEMETRY_OPTOUT=1
' >> ~/.bashrc;
