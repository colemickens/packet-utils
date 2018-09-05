#!/usr/bin/env bash

set -euo pipefail
set -x

PACKET="/home/cole/code/PACKET_CLI/bin/packet"

HOSTNAME="$1"

DEVICE_ID="$("${PACKET}" baremetal list-devices \
  | jq -r "select(.[].hostname==\"${HOSTNAME}\") | .[].id")"

IP_ADDR="$("${PACKET}" baremetal list-device --device-id="${DEVICE_ID}" \
    | jq -r ".ip_addresses[] | select((.cidr==31) and (.public==true)) | .address")"

scp ./configuration-kube.nix root@${IP_ADDR}:/etc/nixos/configuration-kube.nix
scp ./configuration.nix root@${IP_ADDR}:/etc/nixos/configuration.nix
scp ./kube-init.sh root@${IP_ADDR}:/etc/nixos/kube-init.sh
ssh root@${IP_ADDR} -t "/etc/nixos/kube-init.sh"

