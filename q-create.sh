#!/usr/bin/env bash
set -euo pipefail

#FACILITY=ewr1 \
#FACILITY=nrt1 \
#FACILITY=sjc1 \
#FACILITY=ams1 \

#PLAN="c2.medium.x86" \
#PLAN="m2.xlarge.x86" \
#PLAN="x2.xlarge.x86" \

#SPOT_PRICE_MAX=0.2 \
#SPOT_PRICE_MAX=0.4 \

MACHINENAME="pkt-$(printf "%x" "$(date '+%s')")"

#HOURS=10 \

FACILITY=sjc1 \
PLAN="x2.xlarge.x86" \
OS="ubuntu_18_04" \
SPOT_PRICE_MAX=0.15 \
  ./packet.sh device_create "${MACHINENAME}"

