{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./disks.nix
    ../../modules/laptop
    ../../modules/gaming
    ../../modules/obs-studio
    ../../modules/desktop/noctalia
    ../../users/francesco/nixos.nix
  ];

  networking.hostName = "xps9343";

  nixpkgs.config.allowUnfree = true;

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

  modules.desktop.noctalia.enable = true;

  modules.users.francesco.enable = true;

  users.users.francesco.extraGroups = ["gamemode"];

  home-manager.users.francesco = {
    imports = [
      ../../home/desktop/noctalia
    ];

    modules.home.coding = {
      enable = true;
      github.enable = true;
      vscodium.enable = true;
      opencode.enable = true;
    };

    modules.home.desktop.noctalia.enable = true;

    modules.home.persistence = {
      enable = true;
      path = "/persist";
    };

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

  hardware.ckb-next.enable = true;

  system.stateVersion = "25.11";
}
