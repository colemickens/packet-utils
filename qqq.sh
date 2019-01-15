#!/usr/bin/env bash
set -euo pipefail
set -x

allpaths="$(NIX_REMOTE=ssh-ng://root@kix.cluster.lol nix path-info -r "/nix/store/js4x05nsfhb0q4lyapsgbc6ah13126i3-chromium-72.0.3608.4")"

echo "${allpaths}" | while read -r pth; do
  rsync -a "${pth}" ./output/
done

