#!/usr/bin/env bash

set -euo pipefail

target="${1:-"kix.cluster.lol"}"
rsync -avzh /etc/nixos/secrets/ root@${target}:/etc/nixos/secrets
ssh root@${target} chown -R cole:cole /etc/nixcfg
ssh root@${target} chown -R cole:cole /etc/nixpkgs

# TODO: move this to nixcfg/utils probably... that would make a lot more sesne
# and then call sudo -u cole /nixcfg/utils/blah
ssh root@${target} git clone https://github.com/colemickens/cri-tools.git /home/cole/cri-tools
ssh root@${target} chown -R cole:cole /home/cole/cri-tools
ssh root@${target} git clone https://github.com/mozilla/nixpkgs-mozilla.git /etc/nixos/nixpkgs-mozilla
ssh root@${target} "cd /etc/nixpkgs; git worktree add ../nixpkgs-sway sway-wip"
