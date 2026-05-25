{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware.nix
    ../../hardware/graphics/broadwell
    ./disks.nix
    ../../modules/core
    ../../modules/gaming
    ../../modules/obs-studio
    ../../modules/users/francesco
    inputs.impermanence.nixosModules.impermanence
    inputs.niri.nixosModules.niri
  ];

  modules.hardware.graphics.broadwell.enable = true;
  modules.obs-studio.enable = true;

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

  environment.systemPackages = [
    inputs.antigravity-nix.packages.x86_64-linux.default
  ];

  hardware.enableRedistributableFirmware = true;

  programs.niri = {
    enable = true;
    #package = inputs.niri.nixosModules.niri.packages.${pkgs.system}.niri.override {
    #  withXwayland = true;
    #};
  };

  modules.users.francesco.enable = true;

  modules.gaming = {
    enable = true;
    steam.enable = true;
    gamemode.enable = true;
  };

  niri-flake.cache.enable = true;

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
  ];

  hardware.ckb-next.enable = true;

  system.stateVersion = "25.11";
}
