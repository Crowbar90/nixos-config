{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware.nix
    ./disks.nix
    ../../modules/core
    ../../modules/laptop
    ../../modules/obs-studio
    ../../modules/users/francesco
    ../../modules/desktop/niri.nix
    inputs.impermanence.nixosModules.impermanence
  ];

  modules.obs-studio.enable = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "latitude7420";

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

  environment.systemPackages = [
    inputs.antigravity-nix.packages.x86_64-linux.default
  ];

  hardware.enableRedistributableFirmware = true;

  modules.desktop.niri = {
    enable = true;
  };

  modules.users.francesco.enable = true;

  home-manager.users.francesco = {
    modules.persistence = {
      enable = true;
      path = "/persist";
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  nixpkgs.overlays = [
    (import ../../overlays/ckb-next.nix)
    (import ../../overlays/openldap.nix)
  ];

  hardware.ckb-next.enable = true;

  system.stateVersion = "25.11";
}
