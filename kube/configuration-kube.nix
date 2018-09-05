#!nix
{ config, pkgs, lib, ... }:

{
  # set nixPath
  nix.nixPath = [
    "nixpkgs=/etc/nixpkgs:nixos-configuration=/etc/nixos/configuration.nix"
  ];

  environment.noXlibs = true;
  virtualisation = {
    # TODO: these should be "triggered" by the module+options below
    # containerd
    containerd.enable = true;
    # kata
    kata-runtime.enable = true;
    kata-ksm-throttler.enable = true;
    kata-vc-throttler.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    kubernetes = {
      roles = [ "master" "node" ];
      masterAddress = "kix.cluster.lol";

      # TODO: implement/support
      # containerRuntime = "containerd";
      # untrustedRuntime = "kata";

      easyCerts = true;
      apiserver.extraSANs = [ "kix.cluster.lol" ];

      kubelet.extraOpts = "--fail-on-swap=false";
    };
  };
}

