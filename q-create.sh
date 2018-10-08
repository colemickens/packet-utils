#!/usr/bin/env bash

#FACILITY=ewr1 \
#FACILITY=nrt1 \
#FACILITY=sjc1 \

#PLAN="c2.medium.x86" \
#PLAN="m2.xlarge.x86" \

#SPOT_PRICE_MAX=0.2 \
#SPOT_PRICE_MAX=0.4 \

FACILITY=sjc1 \
PLAN="c2.medium.x86" \
HOURS=12 \
SPOT_PRICE_MAX=0.21 \
INIT=/etc/nixcfg/utils/bootstrap-configuration.nix \
  ./packet.sh device_create "${NAME:-"kix.cluster.lol"}"

