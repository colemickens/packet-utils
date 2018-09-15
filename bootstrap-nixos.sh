#!/usr/bin/env bash

set -euo pipefail
set -x

TARGET="${1}"
PLAN="${2}"

scp -r ./nixos-init.sh root@${TARGET}.cluster.lol:/tmp
scp -r /etc/nixos/secrets root@${TARGET}.cluster.lol:/etc/nixos/secrets

ssh -A root@${TARGET}.cluster.lol -t "/tmp/nixos-init.sh ${PLAN}"

