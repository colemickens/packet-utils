#!/usr/bin/env bash

function device_list() {
  set -xeuo pipefail
  curl \
    -H "X-Auth-Token: ${PACKET_API_TOKEN}"
    http://packet.net/devices
}

function device_create() {
  set -xeuo pipefail
  curl \
    -X PUT \
    -H "X-Auth-Token: ${PACKET_API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${2}" \
    "https://api.packet.net/projects/${PACKET_PROJECT_ID}/devices"
}

function device_update() {
  set -xeuo pipefail
  curl \
    -X PUT \
    -H "X-Auth-Token: ${PACKET_API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${2}" \
    "https://api.packet.net/devices/${1}"
}

cmd="$1"
shift
"$cmd" "$@"

