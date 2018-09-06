#!/usr/bin/env bash

PACKET="/home/cole/code/PACKET_CLI/bin/packet"

PRICES="$("${PACKET}" admin spot-prices)"
CURRENT_SPOT_PRICE_EWR1="$(echo "${PRICES}" | jq -r '.ewr1."c2.medium.x86"')"
CURRENT_SPOT_PRICE_SJC1="$(echo "${PRICES}" | jq -r '.sjc1."c2.medium.x86"')"

echo "-----------------------------"
echo "SPOT PRICE: EWR1: ${CURRENT_SPOT_PRICE_EWR1}"
echo "SPOT PRICE: SJC1: ${CURRENT_SPOT_PRICE_SJC1}"
echo "-----------------------------"

