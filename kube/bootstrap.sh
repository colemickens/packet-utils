#!/usr/bin/env bash

set -euo pipefail
set -x

scp ./kube-init.sh root@kix.cluster.lol:/tmp/
scp -r /etc/nixos/secrets root@kix.cluster.lol:/etc/nixos/secrets

ssh -A root@kix.cluster.lol -t "/tmp/kube-init.sh"

