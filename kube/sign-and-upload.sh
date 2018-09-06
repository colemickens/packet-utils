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
    --volume "${store_dir}:/nixcache:ro" \
      docker.io/microsoft/azure-cli az $@
}

az storage blob container delete --name nixcache

az storage blob container create --help

az storage blob container create \
  -name nixcache \
  --public-access container

az storage blob upload-batch \
  --if-none-match '*' \
  --source /nixcache \
  --destination nixcache \

