#!/usr/bin/env bash

set -euo pipefail
set -x

PACKET="/home/cole/code/PACKET_CLI/bin/packet"

HOSTNAME="epyc-$(date '+%Y%m%d-%H%M%S')"
TERMINATION_TIME="$(date --date='5 hour' '+%s')"
SPOT_PRICE_MAX="0.1"

"${PACKET}" baremetal \
  create-device \
    --spot-instance \
    --spot-price-max="${SPOT_PRICE_MAX}" \
    --facility="ewr1" \
    --plan="c2.medium.x86" \
    --os-type="nixos_18_03" \
    --termination-time="${TERMINATION_TIME}" \
    --hostname="${HOSTNAME}" \
    #--userfile="./configuration-kube.nix"

./bootstrap.sh "${HOSTNAME}"

