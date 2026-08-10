{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware.nix
    ../../hardware/graphics/broadwell
    ./disks.nix
    ../../modules/core
    ../../modules/laptop
    ../../modules/obs-studio
    ../../modules/users/francesco
    ../../modules/desktop/niri.nix
    ../../modules/home/desktop/niri.nix
    inputs.impermanence.nixosModules.impermanence
  ];

  modules.hardware.graphics.broadwell.enable = true;
  modules.obs-studio.enable = true;

  nixpkgs.config.allowUnfree = true;

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

  modules.desktop.niri = {
    enable = true;
  };

  modules.users.francesco.enable = true;

  home-manager.users.francesco = {
    modules.coding = {
      git.enable = true;
      github.enable = true;
      vscodium.enable = true;
      opencode.enable = true;
    };

    modules.desktop.niri.enable = true;
    modules.persistence = {
      enable = true;
      path = "/persist";
    };

    # Host-specific monitor configuration for xps9343
    programs.niri.settings.outputs = {
      "eDP-1" = {
        mode = {
          width = 3200;
          height = 1800;
          refresh = 60.0;
        };
        scale = 1.5;
      };
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
