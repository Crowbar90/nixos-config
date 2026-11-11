{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
    ./disks.nix
    ../../modules/laptop
    ../../modules/gaming
    ../../modules/obs-studio
    ../../modules/desktop
    ../../users/francesco/nixos.nix
  ];

  networking.hostName = "xps9343";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
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

  modules.desktop = {
    compositors.niri.enable = true;

    shells.noctalia = {
      enable = true;
      # TLP manages power on this laptop; power-profiles-daemon would conflict.
      recommendedServices = false;
    };

    greeter = {
      enable = true;
      defaultSession = "niri";
      keyboard.layout = "it";
      settings.output = {
        width = 3200;
        height = 1800;
        scale = 1.5;
      };
    };
  };

  modules.users.francesco.enable = true;

  users.users.francesco.extraGroups = ["gamemode"];

  home-manager.users.francesco = {
    modules.home.coding = {
      enable = true;
      github.enable = true;
      vscodium.enable = true;
      opencode.enable = true;
    };

    modules.home.desktop = {
      keyboard.layout = "it";
      apps.enable = true;
      compositors.niri.enable = true;
      shells.noctalia.enable = true;

      outputs = [
        {
          name = "eDP-1";
          mode = "3200x1800";
          scale = 1.5;
        }
      ];
    };

    modules.home.persistence = {
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

  hardware.ckb-next.enable = true;

  system.stateVersion = "25.11";
}
