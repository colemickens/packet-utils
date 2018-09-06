#!/usr/bin/env bash

set -euo pipefail
set -x

scp \
  ./kube-init.sh \
  ~/NIX_SIGNING_KEY/nix-cache.cluster.lol-1-secret \
    root@kix.cluster.lol:/tmp/

ssh root@kix.cluster.lol -t "/tmp/kube-init.sh"

