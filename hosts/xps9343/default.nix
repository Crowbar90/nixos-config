{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware.nix
    ./disks.nix
    ../../modules/core
    inputs.impermanence.nixosModules.impermanence
    inputs.niri.nixosModules.niri
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
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  hardware.enableRedistributableFirmware = true;

  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.system}.niri {
      withXwayland = true;
    };
  };

  system.stateVersion = "25.11";
}
