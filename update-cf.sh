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

exitcode=0

for RECORD in ${DEVICE_HOSTNAMES}; do
  echo "----------------------------------------------------------------------------"
  IP="$(echo "${DEVICES_OUT}" | jq -r ".[] | select(.hostname==\"${RECORD}\").ip_addresses[] | select((.address_family==4) and (.public==true)).address")"
  if [[ -z "${IP}" ]]; then
    exitcode=-1
    echo "${RECORD}: not ready yet"
    continue
  fi

  RECORD=${RECORD%".${DOMAIN}"}
  echo "setting ${RECORD} = ${IP}"
  cfcli rm "${RECORD}" || true
  cfcli add --type "A" "${RECORD}" "${IP}" --ttl 120
done

exit ${exitcode}

