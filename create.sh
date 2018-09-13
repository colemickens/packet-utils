#!/usr/bin/env bash

set -euo pipefail
set -x

# Until we move to curl based CLI, we need to
# use Cole's patched CLI that has the termination_time
# support.
PACKET="/home/cole/code/PACKET_CLI/bin/packet"

# Hostname of the Packet device
HOSTNAME="${HOSTNAME:-kix.cluster.lol}"

# Bid price for the spot market
SPOT_PRICE_MAX="${SPOT_PRICE_MAX:-0.2}"

# Number of hours the instance is configured to run for.
# It is auto-terminated at this time, if not early due to
# changes in the spot market.
HOURS="${HOURS:-4}"
TERMINATION_TIME="$(date --date="${HOURS} hour" '+%s')"

# Facility to deploy to.
# (c2.medium.x86 are only available in ewr1/sjc1)
FACILITY="${FACILITY:-"ewr1"}"

"${PACKET}" baremetal \
  create-device \
    --spot-instance \
    --spot-price-max="${SPOT_PRICE_MAX}" \
    --facility="${FACILITY}" \
    --plan="c2.medium.x86" \
    --os-type="nixos_18_03" \
    --termination-time="${TERMINATION_TIME}" \
    --hostname="${HOSTNAME}" \
