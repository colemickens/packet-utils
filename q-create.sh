#!/usr/bin/env bash
set -euo pipefail

#FACILITY=ewr1 \
#FACILITY=nrt1 \
#FACILITY=sjc1 \
#FACILITY=ams1 \

#PLAN="c2.medium.x86" \
#PLAN="m2.xlarge.x86" \

#SPOT_PRICE_MAX=0.2 \
#SPOT_PRICE_MAX=0.4 \

MACHINENAME="pkt-$(printf "%x" "$(date '+%s')")"

FACILITY=sjc1 \
PLAN="c2.medium.x86" \
HOURS=4 \
SPOT_PRICE_MAX=0.3 \
  ./packet.sh device_create "${MACHINENAME}" >/dev/null
echo

