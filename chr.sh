o=()
o+=("--option" "build-cores" "0")
o+=("--option" "narinfo-cache-negative-ttl" "0")
o+=("--option" "binary-caches" "https://cache.nixos.org https://nixpkgs-wayland.cachix.org https://colemickens.cachix.org")
o+=("--option" "substituters" "https://cache.nixos.org https://nixpkgs-wayland.cachix.org https://colemickens.cachix.org")
o+=("--option" "trusted-public-keys" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA= colemickens.cachix.org-1:oIGbn9aolUT2qKqC78scPcDL6nz7Npgotu644V4aGl4=")

export url='https://github.com/colemickens/nixpkgs/archive/chromium-upstream.tar.gz'
nix-build \
  "${o[@]}" \
  "${url}" \
  -A chromium -A chromiumBeta -A chromiumDev \
    | cachix push colemickens

export url='https://github.com/colemickens/nixpkgs/archive/chromium-upstream-ozone.tar.gz'
nix-build \
  "${o[@]}" \
   -E "with (import (builtins.fetchTarball \"${url}\") {});  chromium.override{ channel=\"dev\"; useVaapi=false; useOzone=true;}" \
     | cachix push colemickens

