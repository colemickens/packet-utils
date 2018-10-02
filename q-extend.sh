#!/usr/bin/env bash

temp="$(mktemp)"
offset="${1:-"15 minutes"}"
remote="${2:-"kix.cluster.lol"}"
device="$(./packet.sh device_get "${remote}")"
tt="$(echo "${device}" | jq -r .termination_time)"

newtt="$(date -d "${tt} + ${offset}" --iso-8601=seconds --universal)"

echo "${device}" | jq -r ".termination_time=\"${newtt}\"" > "${temp}"
./packet.sh device_update "${remote}" "${temp}"

