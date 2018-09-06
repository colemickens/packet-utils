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

if [[ ! -d /etc/packet-utils ]]; then
  git clone https://github.com/colemickens/packet-utils /etc/packet-utils
  cd /etc/packet-utils
fi

mv /etc/nixos/configuration.nix "/etc/nixos/configuration-backup-$(date '+%s').nix"
ln -s /etc/packet-utils/kube/configuration.nix /etc/nixos/configuration.nix

cat <<EOF >/root/.gitconfig
[user]
  email = cole.mickens@gmail.com
  name = Cole Mickens
EOF

export NIX_PATH=nixpkgs=/etc/nixpkgs:nixos-config=/etc/nixos/configuration.nix
nixos-rebuild switch \
  --option extra-binary-caches \
  "https://kixstorage.blob.core.windows.net/nixcache https://cache.nixos.org https://hydra.nixos.org" \
  --option trusted-public-keys \
  "nix-cache.cluster.lol-1:Pa4IudNcMNF+S/CjNt5GmD8vVJBDf8mJDktXfPb33Ak= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
