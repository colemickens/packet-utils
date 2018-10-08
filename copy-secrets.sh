#!/usr/bin/env bash

set -euo pipefail

target="${1:-"root@kix.cluster.lol"}"
rsync -avzh /etc/nixos/secrets/ ${target}:/etc/nixos/secrets

