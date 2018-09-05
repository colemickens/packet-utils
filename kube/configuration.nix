# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./packet.nix
      ./configuration-kube.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "18.03"; # Did you read the comment?

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

  boot.kernelPackages = pkgs.linuxPackages_4_18;
}
