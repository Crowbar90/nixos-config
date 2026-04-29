{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware.nix
    ./disks.nix
    ../../modules/core
    inputs.impermanence.nixosModules.impermanence
    inputs.niri.nixosModules.niri
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [ "https://niri.cachix.org" ];
    trusted-public-keys = [ "niri.cachiz.org-1:Wv0Om607ZpSsdY5Z3jnLMc7sy386XPFpYpSrqP3zX5E=" ];
  };

  networking.hostName = "xps9343";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  hardware.enableRedistributableFirmware = true;

  programs.niri = {
    enable = true;
    #package = inputs.niri.nixosModules.niri.packages.${pkgs.system}.niri.override {
    #  withXwayland = true;
    #};
  };

  niri-flake.cache.enable = true;

  system.stateVersion = "25.11";
}
