#!/usr/bin/env bash

./packet.sh device_termination_time kix.cluster.lol

yad --notification --listen

# capture stdin for that proc
# write to it as the status of our VM changes...

