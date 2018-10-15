#!/usr/bin/env bash
set -euo pipefail

#FACILITY=ewr1 \
#FACILITY=nrt1 \
#FACILITY=sjc1 \

#PLAN="c2.medium.x86" \
#PLAN="m2.xlarge.x86" \

#SPOT_PRICE_MAX=0.2 \
#SPOT_PRICE_MAX=0.4 \

echo "==> Boot Machine Start"
FACILITY=sjc1 \
PLAN="c2.medium.x86" \
HOURS=12 \
SPOT_PRICE_MAX=0.22 \
INIT=/etc/nixcfg/utils/bootstrap/default.nix \
  ./packet.sh device_create "${NAME:-"kix.cluster.lol"}"
# TODO: start `device_sos_log` in the background for someone to be able to tail
echo
echo "==> Boot Machine In Progress"

echo "==> Waiting to Update DNS"

sleep $(( 60 * 2 ))
echo "==> Update DNS Start"
until timeout 10 ./update-cf.sh; do
  sleep 30
done
echo "==> Update DNS Complete"


echo "==> Copying Secrets Start"
sleep $(( 60 * 10 ))
until timeout 3 ./copy-secrets.sh kix.cluster.lol -e "ssh -o StrictHostKeyChecking=no"; do
  sleep 30
done
echo "==> Copying Secrets Complete"

# TODO: wait for cole@kix.cluster.lol to be available?

