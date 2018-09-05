#!/usr/bin/env bash

set -euo pipefail
set -x

PACKET="/home/cole/code/PACKET_CLI//bin/packet"

# packet baremetal list-devices | jq -r '.[].id'
#  | packet baremetal delete-device --device-id="${d}"

retval=0
for d in $(packet baremetal list-devices | jq -r '.[].id'); do
    echo "${d}"
    if ! packet baremetal delete-device --device-id "${d}"; then
        retval=1
    fi
done

exit $retval

