#!/usr/bin/env bash

set -euo pipefail
set -x

#PACKET="/home/cole/code/PACKET_CLI//bin/packet"

# packet baremetal list-devices | jq -r '.[].id'
#  | packet baremetal delete-device --device-id="${d}"

# array?
DEVICES=$(./lib/packet.sh devices_list | jq -r '.[].id')

for d in ${DEVICES}; do
  ./lib/packet.sh device_delete "${d}"
done

