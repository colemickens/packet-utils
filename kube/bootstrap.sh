#!/usr/bin/env bash

set -euo pipefail
set -x

scp \
  ./configuration.nix \
  ./kube-init.sh \
  ./sign-and-upload.sh \
  ~/NIX_SIGNING_KEY/nix-cache.cluster.lol-1-secret \
    root@kix.cluster.lol:/etc/nixos/

ssh root@kix.cluster.lol -t "/etc/nixos/kube-init.sh"

