#!/usr/bin/env bash

set -euo pipefail
set -x

# cloudflare
function cfcli() {
  command cfcli \
  --email "${EMAIL}" \
  --token "${TOKEN}" \
  --domain "${DOMAIN}" \
  $@
}
TOKEN="$(cat /etc/nixos/secrets/cf-token)"
EMAIL="$(cat /etc/nixos/secrets/cf-email)"

DOMAIN="cluster.lol"
RECORD="kix"
IP=1.2.3.4

# packet
PACKET="/home/cole/code/PACKET_CLI/bin/packet"
IP="$("${PACKET}" baremetal list-devices \
  | jq -r ".[] | select(.hostname=\"${RECORD}.${DOMAIN}\").ip_addresses[] | select((.cidr==31) and (.public==true)).address")"

cfcli rm "${RECORD}" || true
cfcli add --type "A" "${RECORD}" "${IP}" --ttl 120

