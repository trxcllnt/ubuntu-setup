#!/usr/bin/env bash

set -e
set -o errexit

cd $(dirname "$(realpath "$0")")/../

# Install `pass` if not installed
if [ -n "$(apt policy pass 2> /dev/null | grep -i 'Installed: (none)')" ]; then
    sudo apt update && sudo apt install -y pass
fi

# Install pass docker-credential-helpers if not installed
if [ -z "$(which docker-credential-pass)" ]; then
    DOCKER_CREDENTIAL_HELPERS_VERSION=$(curl -s https://api.github.com/repos/docker/docker-credential-helpers/releases/latest | jq -r ".tag_name" | tr -d 'v')
    curl -fsSL --compressed \
        https://github.com/docker/docker-credential-helpers/releases/download/v$DOCKER_CREDENTIAL_HELPERS_VERSION/docker-credential-pass-v$DOCKER_CREDENTIAL_HELPERS_VERSION-amd64.tar.gz \
      | tar -xzO \
      | sudo tee /usr/local/bin/docker-credential-pass >/dev/null \
     && sudo chmod +x /usr/local/bin/docker-credential-pass
fi

# 1. Create a PGP key

while true; do
    GENERATE_NEW_GPG_KEY=""
    read -p "1. Generate a new secret GPG key? (Y/n)" GENERATE_NEW_GPG_KEY </dev/tty
    if [[ "$GENERATE_NEW_GPG_KEY" == "" ]]; then
        GENERATE_NEW_GPG_KEY="Y";
    fi
    case $GENERATE_NEW_GPG_KEY in
        [Nn]* ) break;;
        [Yy]* ) gpg --full-generate-key; break;;
        * ) >&2 echo "Please answer 'yes' or 'no'";;
    esac
done

echo -e '\n\nListing secret GPG keys:\n\n'
gpg --list-secret-keys --keyid-format LONG
GPG_KEY_ID_TO_USE_FOR_DOCKER_CREDENTIAL_PASS=""

read -p \
    "Please enter the ID of the GPG key to use (i.e. the long hash next to 'pub' or 'sec'):" \
    GPG_KEY_ID_TO_USE_FOR_DOCKER_CREDENTIAL_PASS </dev/tty

while true; do
    GPG_KEY_ID_TO_USE_FOR_DOCKER_CREDENTIAL_PASS_IS_CORRECT=""
    read -p "$MSG (default: $DEFAULT) " SELECTION </dev/tty
    read -p "You entered \"$GPG_KEY_ID_TO_USE_FOR_DOCKER_CREDENTIAL_PASS\"
Is this correct? (Y/n)" GPG_KEY_ID_TO_USE_FOR_DOCKER_CREDENTIAL_PASS_IS_CORRECT </dev/tty
    if [[ "$GPG_KEY_ID_TO_USE_FOR_DOCKER_CREDENTIAL_PASS_IS_CORRECT" == "" ]]; then
        GPG_KEY_ID_TO_USE_FOR_DOCKER_CREDENTIAL_PASS_IS_CORRECT="Y";
    fi
    case $GPG_KEY_ID_TO_USE_FOR_DOCKER_CREDENTIAL_PASS_IS_CORRECT in
        [Nn]* ) echo "Exiting"; exit 1;;
        [Yy]* ) break;;
        * ) >&2 echo "Please answer 'yes' or 'no'";;
    esac
done

# 2. Initialize pass

echo "
2. Initializing pass for GPG key \"$GPG_KEY_ID_TO_USE_FOR_DOCKER_CREDENTIAL_PASS\"
"
pass init $GPG_KEY_ID_TO_USE_FOR_DOCKER_CREDENTIAL_PASS
echo "
Inserting docker-credential-helpers/docker-pass-initialized-check pass.

Please enter 'pass is initialized' at the following password prompt.
"
pass insert docker-credential-helpers/docker-pass-initialized-check

# 3. Configure docker to use pass for credentials storage

echo "
3. Configuring docker to use \"credsStore\": \"pass\"
"

mkdir -p ~/.docker
if [ ! -f ~/.docker/config.json ]; then
    echo '{"credsStore": "pass"}' >> ~/.docker/config.json
else
    tmp_docker_config_json="$(mktemp -q)"
    echo '{"credsStore": "pass"}' >> ~/.docker/config.json
    cat ~/.docker/config.json | jq -s '.[0] * .[1]' > "$tmp_docker_config_json"
    cat "$tmp_docker_config_json" > ~/.docker/config.json
fi

echo "
4. Logging in to dockerhub to ensure local credentials are stored securely.

If docker prints a warning that the credentials are stored in plaintext:

1. Edit $(realpath ~/.docker/config.json)
2. Remove the \"auths\" entry for https://index.docker.io/v1/
3. Re-run \"docker login https://index.docker.io/v1/\"
"

# 4.a Logout of dockerhub
docker logout https://index.docker.io/v1/ || true 2>/dev/null

# 4.b Login to dockerhub
docker login https://index.docker.io/v1/
