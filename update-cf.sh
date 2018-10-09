#!/usr/bin/env bash

set -euo pipefail

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
DOMAIN="${DOMAIN:-"$(cat /etc/nixos/secrets/cf-domain)"}"

DEVICES_OUT="$(./packet.sh device_list)"
DEVICE_HOSTNAMES="$(echo "${DEVICES_OUT}" | jq -r ".[].hostname")"

for RECORD in ${DEVICE_HOSTNAMES}; do
  echo "----------------------------------------------------------------------------"
  IP="$(echo "${DEVICES_OUT}" | jq -r ".[] | select(.hostname==\"${RECORD}\").ip_addresses[] | select((.address_family==4) and (.public==true)).address")"
  if [[ -z "${IP}" ]]; then
    echo "not ready yet"
    continue
  fi

  RECORD=${RECORD%".${DOMAIN}"}
  cfcli rm "${RECORD}" || true
  cfcli add --type "A" "${RECORD}" "${IP}" --ttl 120
done

