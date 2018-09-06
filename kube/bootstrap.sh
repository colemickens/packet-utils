#!/usr/bin/env bash

set -euo pipefail
set -x

#PACKET="/home/cole/code/PACKET_CLI/bin/packet"

#HOSTNAME="$1"

#DEVICE_ID="$("${PACKET}" baremetal list-devices \
#  | jq -r "select(.[].hostname==\"${HOSTNAME}\") | .[].id")"

#IP_ADDR="$("${PACKET}" baremetal list-device --device-id="${DEVICE_ID}" \
#    | jq -r ".ip_addresses[] | select((.cidr==31) and (.public==true)) | .address")"

#scp ./configuration-kube.nix root@${IP_ADDR}:/etc/nixos/configuration-kube.nix
#scp ./configuration.nix root@${IP_ADDR}:/etc/nixos/configuration.nix
#scp ./kube-init.sh root@${IP_ADDR}:/etc/nixos/kube-init.sh
#scp ./sign-and-upload.sh root@${IP_ADDR}:/etc/nixos/sign-and-upload.sh
#scp ~/NIX_SIGNING_KEY/nix-cache.cluster.lol-1-secret root@${IP_ADDR}:/etc/nixos/nix-cache.cluster.lol-1-secret

scp \
  ./configuration-kube.nix \
  ./configuration.nix \
  ./kube-init.sh \
  ./sign-and-upload.sh \
  ~/NIX_SIGNING_KEY/nix-cache.cluster.lol-1-secret \
    root@kix.cluster.lol:/etc/nixos/

ssh root@kix.cluster.lol -t "/etc/nixos/kube-init.sh"

