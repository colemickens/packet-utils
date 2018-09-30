#!/usr/bin/env bash

out="$(/home/cole/code/packet-utils/packet.sh \
  device_termination_time "${NAME:-"kix.cluster.lol"}" 2>/dev/null)"

echo "packet:${out}"

