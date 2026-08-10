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
    inputs.niri.nixosModules.niri
  ];

  modules.obs-studio.enable = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "latitude7420";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

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

  programs.niri.enable = true;
  programs.xwayland.enable = true;
  security.polkit.enable = true;

  modules.users.francesco.enable = true;

  home-manager.users.francesco = {
    imports = [
      ../../modules/home/desktop/niri.nix
    ];

    modules.coding = {
      vscodium.enable = true;
      opencode.enable = true;
    };

    modules.persistence = {
      enable = true;
      path = "/persist";
    };

    modules.desktop.niri = {
      enable = true;
    };

    programs.niri.settings.outputs = {
      "eDP-1" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        };
        scale = 1;
      };
    };

    home.packages = with pkgs; [
      calibre
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  nixpkgs.overlays = [
    (import ../../overlays/ckb-next.nix)
    (import ../../overlays/openldap.nix)
  ];

  hardware.ckb-next.enable = true;

  system.stateVersion = "25.11";
}
