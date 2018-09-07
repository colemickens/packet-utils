#!/usr/bin/env bash

set -euo pipefail
set -x

scp \
  ./kube-init.sh \
  ~/NIX_SIGNING_KEY/nix-cache.cluster.lol-1-secret \
  ~/NIX_SIGNING_KEY/kixstorage-secret \
    root@kix.cluster.lol:/tmp/

ssh -A root@kix.cluster.lol -t "/tmp/kube-init.sh"

