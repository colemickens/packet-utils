# packet-utils

This repo is meant to help me manage (a|some) Packet machines.

* `./packet.sh` is a sort of client CLI for packet:
  * `./packet.sh device_get [device_hostname]`
* `./q-[script].sh` are even higher level helpers:
  * `./q-create.sh` will create a spot instance for some number of hours. It's meant to be editted each time before run, because who likes huge command line strings and relying on shell history?
  * `./q-extend.sh [duration] [device_hostname]` will extend the termination time of a Packet machine, based on it's device name. Example `./q-extend.sh "30 minutes" "kix.cluster.lol"`.
  * `./q-termtime.sh [device_hostname]` will spit out the remaining time in a human readable form. Meant to be used with i3status(-rust) or some such.

Also, there is `./update-cf.sh` that will create DNS entries at Cloudflare that point at any currently-deployed Packet machines in my project.

