#!/usr/bin/env bash

set -x
set -euo pipefail

key="/etc/nixos/secrets/nix-cache.cluster.lol-1-secret"
store_dir=/tmp/nixcache
store_dir=/tmp/tmp.e0AzRg4ClL
store="file://${store_dir}"
derivation="$(readlink -f /nix/var/nix/profiles/system)"

mkdir -p "${store_dir}"
#nix copy --to "${store}" "${derivation}"

#nix sign-paths --store "${store}" -k "${key}" "${derivation}" -r

# upload to azure now
docker run \
  --net=host \
  --env AZURE_STORAGE_CONNECTION_STRING="DefaultEndpointsProtocol=https;AccountName=kixstorage;AccountKey=PMAU4DVs9wYdST3JKYKr4KqS6DxoJKyWKBf0ATRxe9RBAj9CSWmu6bVMI1LMyLF05NROF68x4nMvhfpQNqLJ1w==;EndpointSuffix=core.windows.net" \
  --volume "${store_dir}:/nix-cache:ro" \
    docker.io/microsoft/azure-cli \
      az storage blob upload-batch \
        --if-none-match '*' \
        --source /nix-cache \
        --destination nixcache \

#-it    docker.io/microsoft/azure-cli /bin/bash
