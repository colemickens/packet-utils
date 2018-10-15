#!/usr/bin/env bash
set -x
set -euo pipefail

target="${1:-"root@kix.cluster.lol"}"

# the rest of the args are modifiers for rsync
rsync -avzh /etc/nixos/secrets/ ${target}:/etc/nixos/secrets

