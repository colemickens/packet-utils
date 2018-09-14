#!/usr/bin/env bash

function device_list() {
  set -xeuo pipefail
  curl \
    -H "X-Auth-Token: ${PACKET_API_TOKEN}" \
    "https://api.packet.net/projects/${PACKET_PROJECT_ID}/devices/"
}

function device_create() {
  set -xeuo pipefail
  curl \
    -X POST \
    -H "X-Auth-Token: ${PACKET_API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${1}" \
    "https://api.packet.net/projects/${PACKET_PROJECT_ID}/devices"
}

function device_update() {
  set -xeuo pipefail
  curl \
    -X PUT \
    -H "X-Auth-Token: ${PACKET_API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${2}" \
    "https://api.packet.net/devices/${1}/"
}

function device_list_events() {
  set -xeuo pipefail
  DEVICE_ID="$(packet baremetal list-devices | jq -r '.[0].id')"
  curl \
    -H "X-Auth-Token: ${PACKET_API_TOKEN}" \
    "https://api.packet.net/devices/${DEVICE_ID}/events"
}

cmd="$1"
shift
"$cmd" "$@"

