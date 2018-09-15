#!/usr/bin/env bash

set -x
set -euo pipefail

echo "PLAN=${1}"

# misc for dev only, remove later
nix-env -iA nixos.gitAndTools.gitFull nixos.neovim nixos.htop nixos.psmisc nixos.tmux nixos.ripgrep

# TODO: declarative git repo management / my other idea gitbgsync
# TODO: prototype + blog
if [[ ! -d /etc/nixpkgs ]]; then
  git clone https://github.com/colemickens/nixpkgs /etc/nixpkgs
  cd /etc/nixpkgs
  git checkout kata
  git remote set-url origin "git@github.com:colemickens/nixpkgs.git"
fi

if [[ ! -d /etc/packet-utils ]]; then
  git clone https://github.com/colemickens/packet-utils /etc/packet-utils
  cd /etc/packet-utils
  git remote set-url origin "git@github.com:colemickens/packet-utils.git"
fi

mv /etc/nixos/configuration.nix "/etc/nixos/configuration-backup-$(date '+%s').nix"
ln -s /etc/packet-utils/plans/${PLAN}/configuration.nix /etc/nixos/configuration.nix

# TODO: remove (or find more elegant nix-y way to import my normal nixcfg, (which should actually be not that hard)
# TODO: would be very cool blog post, actually. totally could login as my normal user and have all of my softawre without even thinkng about it
# TODO: demo:
#       - docker container, with my user+config
#       - vm, same thing
#       etc
cat <<EOF >/root/.gitconfig
[user]
  email = cole.mickens@gmail.com
  name = Cole Mickens
EOF

# TODO: blog post about the azure storage for massive cheap speedup
export NIX_PATH=nixpkgs=/etc/nixpkgs:nixos-config=/etc/nixos/configuration.nix
nixos-rebuild switch \
  --option extra-binary-caches \
  "https://kixstorage.blob.core.windows.net/nixcache https://cache.nixos.org https://hydra.nixos.org" \
  --option trusted-public-keys \
  "nix-cache.cluster.lol-1:Pa4IudNcMNF+S/CjNt5GmD8vVJBDf8mJDktXfPb33Ak= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="

reboot

