#!/usr/bin/env bash
set -euo pipefail
set -x

#export FACILITY=asm1
#export FACILITY=ewr1
#export FACILITY=nrt1
export FACILITY=sjc1

#export PLAN="c2.medium.x86"
#export PLAN="m2.xlarge.x86"
export PLAN="x2.xlarge.x86"

export SPOT_PRICE_MAX=0.50
export HOURS=4

export MACHINENAME="pkt-$(printf "%x" "$(date '+%s')")"

export OS="nixos_19_03"

./packet.sh device_create "${MACHINENAME}"


while true; do
  IP="$(./packet.sh device_list | jq -r ".[] | select(.hostname==\"${MACHINENAME}\").ip_addresses[] | select((.address_family==4) and (.public==true)).address")"
  if ./bootstrap-nixos_19_03.sh "${IP}"; then
    break
  fi
  sleep 10
done
