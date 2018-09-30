#!/usr/bin/env bash

set -euo pipefail

target="${1}"
rsync -avzh /etc/nixos/secrets/ root@${target}:/etc/nixos/secrets

