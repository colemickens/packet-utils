#!/usr/bin/env bash
set -euo pipefail

export PACKET_API_TOKEN="${PACKET_API_TOKEN:-"$(cat $HOME/.secrets/packet-apitoken)"}"
export PACKET_PROJECT_ID="${PACKET_PROJECT_ID:-"$(cat $HOME/.secrets/packet-projectid)"}"

export PACKET_DEFAULT_DEVICE="kix.cluster.lol"

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
  set -x
  if [ "${HOURS:-""}" != "" ]; then
    HOURS="${HOURS}"
    export TERMINATION_TIME="${TERMINATION_TIME:-"$(TZ=UTC date --date="+${HOURS} hour" --iso-8601=seconds)"}"
    extra="${extra:-},\"termination_time\": ${TERMINATION_TIME}"
  fi
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
    "operating_system": "${OS:-"nixos_18_03"}",
    "hostname": "${1}"
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
  DEVICE="${1:-"${PACKET_DEFAULT_DEVICE}"}"
  device_list | jq -r "[.[] | select(.hostname==\"${DEVICE}\").id][0]"
}

function device_get() {
  DEVICE="${1:-"${PACKET_DEFAULT_DEVICE}"}"
  device_list | jq -r "[.[] | select(.hostname==\"${DEVICE}\")][0]"
}

function device_sos_log() {
  DEVICE="${1:-"${PACKET_DEFAULT_DEVICE}"}"
  ADDR="$(device_get "${DEVICE}" | jq -r '. | "\(.id)@sos.\(.facility.code).packet.net"')"
  echo "" > /tmp/packet.log
  while true; do
    echo "<<<<<<<<<<<<<<<reconnect>>>>>>>>>>>>>>>" > /tmp/packet.log
    ssh "${ADDR}" > /tmp/packet.log || true
    sleep 1
  done
}

function device_sos() {
  DEVICE="${1:-"${PACKET_DEFAULT_DEVICE}"}"
  set -x
  ssh "$(device_get "${DEVICE}" | jq -r '. | "\(.id)@sos.\(.facility.code).packet.net"')"
  set +x
}

function device_termination_time() {
  DEVICE="${1:-"${PACKET_DEFAULT_DEVICE}"}"
  t="$(device_get "${DEVICE}" | jq -r '.termination_time')"
  now="$(date '+%s')"
  later="$(date -d "${t}" '+%s')"
  seconds="$((${later} - ${now}))"
  echo $((seconds/86400))d$(date -d "1970-01-01 + $seconds seconds" "+%H:%M:%S")
}


function device_update() {
  DEVICE="${1:-"${PACKET_DEFAULT_DEVICE}"}"
  c \
    -X PUT \
    -H "Content-Type: application/json" \
    -d "$(cat ${2})" \
    "https://api.packet.net/devices/$(device_id ${DEVICE})/"
}

function device_events() {
  DEVICE="${1:-"${PACKET_DEFAULT_DEVICE}"}"
  c "https://api.packet.net/devices/$(device_id ${DEVICE})/events" | jq -r '.events'
}

function device_delete() {
  DEVICE="${1:-"${PACKET_DEFAULT_DEVICE}"}"
  c -X DELETE "https://api.packet.net/devices/$(device_id ${DEVICE})"
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

