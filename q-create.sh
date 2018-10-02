#!/usr/bin/env bash

FACILITY=ewr1 \
PLAN="c2.medium.x86" \
HOURS=12 \
SPOT_PRICE_MAX=0.2 \
INIT=/etc/nixcfg/utils/bootstrap-configuration.nix \
  ./packet.sh device_create "${NAME:-"kix.cluster.lol"}"
