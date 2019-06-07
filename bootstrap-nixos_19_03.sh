#!/usr/bin/env bash
set -euo pipefail

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

##
# need to make my user trusted!
##

CONFIG_HOME="/root"
CODE_HOME="/home/cole"
ssh "root@${IP}" "mkdir -p ${CONFIG_HOME}/.config/cachix"
ssh "root@${IP}" "mkdir -p ${CONFIG_HOME}/.config/nixpkgs/"
scp "${HOME}/.config/cachix/cachix.dhall" "root@${IP}:${CONFIG_HOME}/.config/cachix/"

ssh "root@${IP}"<<EEOOFF
cat<<EOF | sudo bash
    set -x
    set -e

    # TODO: replace with nix-shell
    # TODO: fix update.sh to use nix-shell properly

    nix-channel --add https://nixos.org/channels/nixos-19.03 nixos
    nix-channel --update
    nix-env -iA nixos.git -iA nixos.cachix -iA nixos.tmux -iA nixos.jq

    cachix use nixpkgs-wayland
    cachix use colemickens

    mkdir -p ${CODE_HOME}/code/overlays

    git clone https://github.com/colemickens/nixcfg ${CODE_HOME}/code/nixcfg
    git clone https://github.com/colemickens/nixpkgs-wayland ${CODE_HOME}/code/overlays/nixpkgs-wayland
    git clone https://github.com/colemickens/nixpkgs ${CODE_HOME}/code/nixpkgs -b cmpkgs

    cd ${CODE_HOME}/code/nixcfg
    ./update.sh
EOF
EEOOFF

