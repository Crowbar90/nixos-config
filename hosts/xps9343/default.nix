{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./disks.nix
    ../../modules/core
    inputs.impermanence.nixosModules.impermanence
  ];

  networking.hostName = "xps9343";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManger/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "25.11";
}
