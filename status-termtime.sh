#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
packet="${DIR}/packet.sh"

DEVICES_OUT="$("${packet}" device_list)"
DEVICE_HOSTNAMES="$(echo "${DEVICES_OUT}" | jq -r ".[].hostname")"

for RECORD in ${DEVICE_HOSTNAMES}; do
  TERMTIME="$("${packet}" device_termination_time "${RECORD}")"
  output="${output} (${RECORD} [${TERMTIME}])"
done

if [[ ! -z "${output}" ]]; then
  echo "PKT ${output}"
fi

