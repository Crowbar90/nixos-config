{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware.nix
    # TODO: Add appropriate graphics driver module for midgar hardware
    ./disks.nix
    ../../modules/core
    ../../modules/gaming
    ../../modules/users/francesco
    inputs.impermanence.nixosModules.impermanence
    inputs.niri.nixosModules.niri
  ];

  # TODO: Configure graphics module for your specific GPU
  # modules.hardware.graphics.your_gpu.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [ "https://niri.cachix.org" ];
    trusted-public-keys = [ "niri.cachiz.org-1:Wv0Om607ZpSsdY5Z3jnLMc7sy386XPFpYpSrqP3zX5E=" ];
  };

  networking.hostName = "midgar";

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
  };

  # Configure Francesco user with midgar (desktop) profile
  # Unlike xps9343 (laptop), midgar has:
  # - base: Core Noctalia shell + essential programs
  # - desktop: Desktop-specific config (no touchpad, can customize monitors)
  # - development: Git, GitHub CLI, coding tools
  # - gaming: Gaming-related packages and config
  modules.users.francesco = {
    enable = true;
    profiles = [ "base" "desktop" "development" "gaming" ];
  };

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
