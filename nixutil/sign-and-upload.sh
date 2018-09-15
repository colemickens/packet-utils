#!/usr/bin/env bash

set -x
set -euo pipefail

key="/tmp/nix-cache.cluster.lol-1-secret"
azkey="$(cat /tmp/kixstorage-secret)"

# build cache

mkdir -p "/tmp/nixcache"
nix copy --to 'file:///tmp/nixcache' '/run/current-system'
nix sign-paths \
  --store 'file:///tmp/nixcache' -k "${key}" '/run/current-system' -r

# upload

function az() {
  docker run \
    --net=host \
    --env AZURE_STORAGE_CONNECTION_STRING="${azkey}" \
    --volume "/tmp/nixcache:/nixcache:ro" \
      docker.io/microsoft/azure-cli az $@
}

if az storage container show --name nixcache; then
  az storage container delete --name nixcache
  sleep 60
fi

az storage container create --help

az storage container create \
  --name nixcache \
  --public-access container

time az storage blob upload-batch \
  --if-none-match '\*' \
  --source /nixcache \
  --destination nixcache \
