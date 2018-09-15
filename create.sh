#!/usr/bin/env bash

set -euo pipefail
set -x

## Options

# Hostname of the Packet device
export DEVICENAME="${DEVICENAME:-"kix.cluster.lol"}"

# Bid price for the spot market
export SPOT_PRICE_MAX="${SPOT_PRICE_MAX:-0.2}"

# Number of hours the instance is configured to run for.
# It is auto-terminated at this time, if not early due to
# changes in the spot market.
#export TERMINATION_TIME="${TERMINATION_TIME:-"$(date --date="${HOURS} hour" '+%s')"}"
HOURS="${HOURS:-4}"
export TERMINATION_TIME="${TERMINATION_TIME:-"$(TZ=UTC date --date='+${HOURS} hour' --iso-8601=seconds)"}"

# Facility to deploy to.
export FACILITY="${FACILITY:-"sjc1"}"

# Spot instance or regular instance
export TYPE="${TYPE:-"spot"}"

## Implementation

#cat vm.json | envsubst > "${f}" | ./lib/packet.sh device_create
if [ "${TYPE}" == "spot" ]; then
  f="$(envsubst <vm-spot.json)"
else
  f="$(envsubst <vm.json)"
fi

./lib/packet.sh device_create "${f}"

# TODO: wait 10 seconds, update DNS record, and then poll until it is successfully deployed

