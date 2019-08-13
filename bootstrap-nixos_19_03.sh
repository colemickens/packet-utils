#!/usr/bin/env bash
set -euo pipefail
set -x

# ssh root@${PIP}
#   adduser cole
#   usermod -aG sudo cole
#   su cole
# $ mkdir -p ~/.ssh/
# $ curl 'https://github.com/colemickens.keys' > authorized_keys

# ssh cole@${PIP}

# meant to be run on a new nix_19_03 machine on packet
# this will load my nixpkgs/nixcfg and build/switch to it
IP="${1}"
CONFIG_HOME="/root"
CODE_HOME="/home/cole"

# TODO: there must be a cleaner way. other attempts have failed...
keys="$(ssh-keyscan -H "${IP}")"
if [[ "$(echo "${keys}" | wc -c)" -lte 0 ]]; then exit -1; fi
echo "${keys}" >> "${HOME}/.ssh/known_hosts"

# now we can connect automatically (hopefully?)
ssh "root@${IP}" "mkdir -p ${CONFIG_HOME}/.config/cachix"
ssh "root@${IP}" "mkdir -p ${CONFIG_HOME}/.config/nixpkgs/"
scp "${HOME}/.config/cachix/cachix.dhall" "root@${IP}:${CONFIG_HOME}/.config/cachix/"

ssh -A "root@${IP}"<<EEOOFF
cat<<EOF | sudo bash
    set -x
    set -e

    # TODO: replace with nix-shell
    # TODO: fix update.sh to use nix-shell properly

    nix-channel --add https://nixos.org/channels/nixos-19.03 nixos
    nix-channel --update
    nix-env \
        -iA nixos.git \
        -iA nixos.cachix \
        -iA nixos.tmux \
        -iA nixos.mosh \
        -iA nixos.jq \
        -iA nixos.ripgrep \
        -iA nixos.neovim

    git config --global user.name "Cole Mickens"
    git config --global user.email "cole.mickens@gmail.com"

    cachix use nixpkgs-wayland
    cachix use colemickens

    mkdir -p ${CODE_HOME}/code/overlays

    export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
    git clone git@github.com:colemickens/nixcfg ${CODE_HOME}/code/nixcfg
    git clone git@github.com:colemickens/nixpkgs-wayland ${CODE_HOME}/code/overlays/nixpkgs-wayland
    git clone git@github.com:colemickens/nixpkgs ${CODE_HOME}/code/nixpkgs -b cmpkgs
    (cd ${CODE_HOME}/code/nixpkgs;
     git remote add nixpkgs https://github.com/nixos/nixpkgs;
     git remote add nixpkgs-channels https://github.com/nixos/nixpkgs-channels;
     git remote update
    )

    set +e

    cd ${CODE_HOME}/code/overlays/nixpkgs-wayland
    ./update.sh

    cd ${CODE_HOME}/code/nixcfg
    ./update.sh

    echo "TODO: call Packet to shut down this instance!"
EOF
EEOOFF

