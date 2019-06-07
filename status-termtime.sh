#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
packet="${DIR}/packet.sh"

DEVICES_OUT="$("${packet}" device_list)"
DEVICE_HOSTNAMES="$(echo "${DEVICES_OUT}" | jq -r ".[].hostname")"

for RECORD in ${DEVICE_HOSTNAMES}; do
  TERMTIME="$("${packet}" device_termination_time "${RECORD}")"
  DEVICE="$(echo "${DEVICES_OUT}" | jq -r ".[] | select(.hostname==\"${RECORD}\")")"
  CREATED="$(echo "${DEVICE}" | jq -r ".created_at")"
  CREATED="$(date -d "${CREATED}" '+%s')"
  NOW="$(date '+%s')"
  UPTIME="$(( ${NOW} - ${CREATED} ))"
  UPTIME_HOURS="$(( ${UPTIME} / (60*60) ))"
  # TODO UPTIME PRETTY, we used to have something for this (Term time does ths???)
  PRICE="$(echo "${DEVICE}" | jq -r ".spot_price_max")"
  COST="$(echo "${UPTIME_HOURS} * ${PRICE}" | bc)"
  PLAN="$(echo "${DEVICE}" | jq -r ".plan.slug")"
  output="${output}(${RECORD}: ${PLAN} hr:\$${PRICE} total:\$${COST} up:${UPTIME_HOURS}hrs remain:${TERMTIME}])"
done

if [[ ! -z "${output}" ]]; then
  echo "PKT ${output}"
fi

