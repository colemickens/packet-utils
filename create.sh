#!/usr/bin/env bash

set -euo pipefail
set -x

PACKET="/home/cole/code/PACKET_CLI/bin/packet"

HOSTNAME="kix.cluster.lol"
TERMINATION_TIME="$(date --date='8 hour' '+%s')"
SPOT_PRICE_MAX="${SPOT_PRICE_MAX}"

"${PACKET}" baremetal \
  create-device \
    --spot-instance \
    --spot-price-max="${SPOT_PRICE_MAX}" \
    --facility="ewr1" \
    --plan="c2.medium.x86" \
    --os-type="nixos_18_03" \
    --termination-time="${TERMINATION_TIME}" \
    --hostname="${HOSTNAME}" \

