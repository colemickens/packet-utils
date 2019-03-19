#!/usr/bin/env bash

# ssh root@${PIP}
#   adduser cole
#   usermod -aG sudo cole
#   su cole
# $ mkdir -p ~/.ssh/
# $ curl 'https://github.com/colemickens.keys' > authorized_keys

# ssh cole@${PIP}

bash <(curl https://nixos.org/nix/install)

nix-env -iA cachix -iA git -iA ripgrep -f https://cachix.org/api/v1/install

cachix use nixpkgs-wayland
cachix use colemickens

mkdir ~/code

git clone https://github.com/colemickens/nixcfg ~/code/nixcfg
git clone https://github.com/colemickens/nixpkgs ~/code/nixpkgs -b cmpkgs

git config --global user.email "cole.mickens@gmail.com"
git config --global user.name "Cole Mickens"

cd ~/code/nixcfg
./update.sh

