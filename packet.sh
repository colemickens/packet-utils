#!/usr/bin/env bash

function c() {
  curl -H "X-Auth-Token: ${PACKET_API_TOKEN}" "$@"
}

function spot_prices() {
    c "https://api.packet.net/market/spot/prices" \
      | jq -r '.spot_market_prices'
}

function device_list() {
    c "https://api.packet.net/projects/${PACKET_PROJECT_ID}/devices/" \
      | jq -r '.devices'
}

function device_create() {
  HOURS="${HOURS}"
  export TERMINATION_TIME="${TERMINATION_TIME:-"$(TZ=UTC date --date='+${HOURS} hour' --iso-8601=seconds)"}"

  if [ "${TYPE:-"spot"}" == "spot" ]; then
    spot="\"spot_instance\": true, \"spot_price_max\": ${SPOT_PRICE_MAX}"
  fi

  export dev=$(cat <<EOF
  {
    "facility": "${FACILITY}",
    "plan": "${PLAN}",
    "operating_system": "nixos_18_03",
    "hostname": "${1}",
    "termination_time": "${TERMINATION_TIME}",
    ${spot}
  }
EOF
)

  c \
    -H "Content-Type: application/json" \
    -d "${dev}" \
    "https://api.packet.net/projects/${PACKET_PROJECT_ID}/devices"
}

function device_update() {
  DEVICE_ID="$(device_list | jq -r ".[] | select(.hostname==\"${1}\").id")"
  c \
    -X PUT \
    -H "Content-Type: application/json" \
    -d "${1}" \
    "https://api.packet.net/devices/${DEVICE_ID}/"
}

function device_events() {
  DEVICE_ID="$(device_list | jq -r ".[] | select(.hostname==\"${1}\").id")"
  c \
    "https://api.packet.net/devices/${DEVICE_ID}/events" \
      | jq -r '.events'
}


function device_delete() {
  c \
    -X DELETE \
    -H "Content-Type: application/json" \
    -d "${1}" \
    "https://api.packet.net/devices/${1}"
}


function device_delete_all() {
  DEVICES=$(device_list | jq -r '.[].id')
  for d in ${DEVICES}; do
    ./lib/packet.sh device_delete "${d}"
  done
}

cmd="$1"
if [[ -z "${cmd}" ]]; then
  echo "must specify a command" &>/dev/stderr
  exit -1
fi
shift
(
  set -euo pipefail
  "$cmd" "$@"
)

