#!/usr/bin/env bash

export PACKET_API_TOKEN="${PACKET_API_TOKEN:-"$(cat /etc/nixos/secrets/packet-apitoken)"}"
export PACKET_PROJECT_ID="${PACKET_PROJECT_ID:-"$(cat /etc/nixos/secrets/packet-projectid)"}"

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
  export TERMINATION_TIME="${TERMINATION_TIME:-"$(TZ=UTC date --date="+${HOURS} hour" --iso-8601=seconds)"}"

  if [ "${TYPE:-"spot"}" == "spot" ]; then
    extra="${extra:-},\"spot_instance\": true, \"spot_price_max\": ${SPOT_PRICE_MAX}"
  fi
  if [[ ! -z "${INIT:-}" ]]; then
    extra="${extra:-},\"userdata\": $(jq -Rs . <${INIT})"
  fi

  export dev=$(cat <<EOF
  {
    "facility": "${FACILITY}",
    "plan": "${PLAN}",
    "operating_system": "nixos_18_03",
    "hostname": "${1}",
    "termination_time": "${TERMINATION_TIME}"
   ${extra:-}
  }
EOF
)
echo ${dev}
  c \
    -H "Content-Type: application/json" \
    -d "${dev}" \
    "https://api.packet.net/projects/${PACKET_PROJECT_ID}/devices"
}

function device_id() {
  device_list | jq -r "[.[] | select(.hostname==\"${1}\").id][0]"
}

function device_get() {
  device_list | jq -r "[.[] | select(.hostname==\"${1}\")][0]"
}

function device_sos() {
  ssh "$(device_get "${1}" | jq -r '. | "\(.id)@sos.\(.facility.code).packet.net"')"
}

function device_termination_time() {
  t="$(device_get "${1}" | jq -r '.termination_time')"
  now="$(date '+%s')"
  later="$(date -d "${t}" '+%s')"
  seconds="$((${later} - ${now}))"
  echo $((seconds/86400))d$(date -d "1970-01-01 + $seconds seconds" "+%H:%M:%S")
}


function device_update() {
  c \
    -X PUT \
    -H "Content-Type: application/json" \
    -d "$(cat ${2})" \
    "https://api.packet.net/devices/$(device_id ${1})/"
}

function device_events() {
  c "https://api.packet.net/devices/$(device_id ${1})/events" | jq -r '.events'
}

function device_delete() {
  c -X DELETE "https://api.packet.net/devices/$(device_id ${1})"
}

function device_delete_all() {
  DEVICES=$(device_list | jq -r '.[].id')
  for d in ${DEVICES}; do
    c -X DELETE "https://api.packet.net/devices/${d}"
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

