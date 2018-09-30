#!/usr/bin/env bash

FACILITY=sjc1 \
PLAN="c2.medium.x86" \
HOURS=10 \
SPOT_PRICE_MAX=0.2 \
INIT=/etc/nixcfg/utils/bootstrap-configuration.nix \
  ./packet.sh device_create "${NAME:-"kix.cluster.lol"}"

