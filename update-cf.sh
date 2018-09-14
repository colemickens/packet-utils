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
TOKEN="${CFTOKEN:-"$(cat /etc/nixos/secrets/cf-token)"}"
EMAIL="${CFEMAIL:-"$(cat /etc/nixos/secrets/cf-email)"}"

DOMAIN="${DOMAIN:-"cluster.lol"}"
RECORD="${RECORD:-"kix"}"

# packet
PACKET="/home/cole/code/PACKET_CLI/bin/packet"
IP="$("${PACKET}" baremetal list-devices \
  | jq -r ".[] | select(.hostname=\"${RECORD}.${DOMAIN}\").ip_addresses[] | select((.address_family==4) and (.public==true)).address")"

if [[ -z "${IP}" ]]; then
  echo "not ready yet" &>2
  exit -1
fi

cfcli rm "${RECORD}" || true
cfcli add --type "A" "${RECORD}" "${IP}" --ttl 120
