{ config, pkgs, inputs, ... }:

{
  imports = [
      ./hardware.nix
      ../../hardware/graphics/nvidia
      ./disks.nix
      ../../modules/core
      ../../modules/users/francesco
    inputs.impermanence.nixosModules.impermanence
    ];

  modules.hardware.graphics.nvidia = {
    enable = true;
    open = true;
    useBinaryCache = true;
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "midgar";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;

    timeout = 5;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableRedistributableFirmware = true;

  modules.users.francesco.enable = true;

  home-manager.users.francesco = {
    modules.persistence = {
      enable = true;
      path = "/persist";
    };
  };

  networking.networkmanager.enable = true;

  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb.layout = "it";

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

  programs.nix-ld.enable = true;

  system.stateVersion = "26.05";
}

