o=()
o+=("--option" "build-cores" "0")
o+=("--option" "narinfo-cache-negative-ttl" "0")
o+=("--option" "binary-caches" "https://cache.nixos.org https://nixpkgs-wayland.cachix.org https://colemickens.cachix.org")
o+=("--option" "substituters" "https://cache.nixos.org https://nixpkgs-wayland.cachix.org https://colemickens.cachix.org")
o+=("--option" "trusted-public-keys" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA= colemickens.cachix.org-1:oIGbn9aolUT2qKqC78scPcDL6nz7Npgotu644V4aGl4=")

vaapiCommit="chromium-upstream"
vaapiCommit="3faa77875f9d96956797737cbc8271fb0d71c382"
export url="https://github.com/colemickens/nixpkgs/archive/${vaapiCommit}.tar.gz"
nix-build \
  "${o[@]}" \
  "${url}" \
  -A chromium -A chromiumBeta -A chromiumDev \
    | cachix push colemickens

ozoneCommit="chromium-upstream-ozone"
ozoneCommit="cadecb09b1685436a084d8b52977d3495fc9bb60"
export url="https://github.com/colemickens/nixpkgs/archive/${ozoneCommit}.tar.gz"
nix-build \
  "${o[@]}" \
  "${url}" \
  -A chromiumOzone \
    | cachix push colemickens

