#!/usr/bin/env bash
set -euo pipefail

ZONE="cluster.lol"
RG="dns"

DEVICES_OUT="$(./packet.sh device_list)"
DEVICE_HOSTNAMES="$(echo "${DEVICES_OUT}" | jq -r ".[].hostname")"

exitcode=0

function setip() {
  RECORD="${1}"
  IP="${2}"

  echo "setting ${RECORD} = ${IP}"
  az network dns record-set a delete \
    -g "${RG}" -z "${ZONE}" -n "${RECORD}" --yes
  az network dns record-set a create -g "${RG}" -z "${ZONE}" -n "${RECORD}" --ttl 120
  az network dns record-set a add-record \
    -g "${RG}" -z "${ZONE}" -n "${RECORD}" --ipv4-address "${IP}"
}

IP=""
for RECORD in ${DEVICE_HOSTNAMES}; do
  echo "----------------------------------------------------------------------------"
  IP="$(echo "${DEVICES_OUT}" | jq -r ".[] | select(.hostname==\"${RECORD}\").ip_addresses[] | select((.address_family==4) and (.public==true)).address")"
  if [[ -z "${IP}" ]]; then
    exitcode=-1
    echo "${RECORD}: not ready yet"
    continue
  fi
  setip "${RECORD}" "${IP}"
done

setip "kix" "${IP}"

exit ${exitcode}

