#!nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./packet.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "18.03"; # Did you read the comment?

  boot.kernelPackages = pkgs.linuxPackages_4_18;
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs:
      { linux_4_18 = pkgs.linux_4_18.override {
          extraConfig =
            ''
              MLX5_CORE_EN y
            '';
        };
      };
    };
  };

  nix.nixPath = [
    "nixpkgs=/etc/nixpkgs:nixos-configuration=/etc/nixos/configuration.nix"
  ];

  environment.noXlibs = true;
  virtualisation = {
    # TODO: these should be "triggered" by the module+options below
    # containerd
    #containerd.enable = true;
    # kata
    #kata-runtime.enable = true;
    #kata-ksm-throttler.enable = true;
    #kata-vc-throttler.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    kubernetes = {
      roles = [ "master" "node" ];
      masterAddress = "apiserver.kix.cluster.lol";

      # TODO: implement/support
      # containerRuntime = "containerd";
      # untrustedRuntime = "kata";

      easyCerts = true;
      apiserver.extraSANs = [ "kix.cluster.lol" ];

      kubelet.extraOpts = "--fail-on-swap=false";
    };
  };
}

