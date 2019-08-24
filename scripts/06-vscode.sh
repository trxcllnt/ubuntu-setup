#!/usr/bin/env bash

cd $(dirname "$(realpath "$0")")/../

# Install VSCode and pin to the version with the good sidebar icons
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ && rm packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update \
 && sudo apt install clang-tools-8 bear code=1.36.1-1562627527 \
 && sudo apt-mark hold code \
 && sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 100

code --install-extension --force christian-kohler.npm-intellisense
code --install-extension --force eg2.vscode-npm-script
code --install-extension --force guyskk.language-cython
code --install-extension --force llvm-vs-code-extensions.vscode-clangd
code --install-extension --force ms-python.python
code --install-extension --force msjsdiag.debugger-for-chrome
code --install-extension --force slevesque.shader

mkdir -p ~/.config/Code/User/ && cp vscode/*.json ~/.config/Code/User/
