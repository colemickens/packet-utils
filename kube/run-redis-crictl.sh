#!/usr/bin/env bash

# FOLLOW: https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md

RUNTIME="io.containerd.runtime.kata.v2" # fails with: ctr: no such file or directory: not found
#RUNTIME="io.containerd.runtime.v1.linux" # works

image="docker.io/library/redis:alpine"

echo<<EOF >"/tmp/pod-config.json"
{
  "metadata": {
    "name": "nginx-sandbox",
    "namespace": "default",
    "attempt": 1,
    "uid": "hdishd83djaidwnduwk28bcsb"
  },
  "logDirectory": "/tmp",
    "linux": {
  }
}
EOF
echo<<EOF >"/tmp/container-config.json"
{
  "metadata": {
    "name": "redis0"
  },
  "image":{
    "image": "docker.io/library/redis:alpine"
  },
  "command": [
    "top"
  ],
  "log_path": "redis0/0.log",
  "linux": {
  }
}
EOF

podid="$(crictl runp "/tmp/pod-config.json")"

crictl pull "${image}"

# TODO: why is pod-config repeated, and passed by id???
containerid="$(crictl create ${podid} /tmp/container-config.json /tmp/pod-config.json)"

crictl start "${containerid}"

crictl exec -i -t "${containerid}" ls

