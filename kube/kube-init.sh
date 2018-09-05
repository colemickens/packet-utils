#!/usr/bin/env bash

set -x
set -euo pipefail

# misc for dev only, remove later
nix-env -iA nixos.gitAndTools.gitFull nixos.neovim nixos.htop nixos.psmisc nixos.tmux nixos.ripgrep

if [[ ! -d /etc/nixpkgs ]]; then
  git clone https://github.com/colemickens/nixpkgs /etc/nixpkgs
  cd /etc/nixpkgs
  git checkout kata
  #git cherry-pick -n d111bfe9eda57be257c652d9da47511270814c62
fi

tmux new-session -d -s install 'NIX_PATH=nixpkgs=/etc/nixpkgs:nixos-config=/etc/nixos/configuration.nix nixos-rebuild switch'
tmux at -t install

