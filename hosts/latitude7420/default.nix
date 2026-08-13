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
    ../../modules/desktop/niri
    ../../users/francesco/nixos.nix
  ];

  networking.hostName = "latitude7420";

  nixpkgs.config.allowUnfree = true;

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

  modules.desktop.niri.enable = true;
  modules.users.francesco.enable = true;

  programs.xwayland.enable = true;
  security.polkit.enable = true;

  users.users.francesco.extraGroups = ["gamemode"];

  home-manager.users.francesco = {
    imports = [
      ../../home/desktop/niri
    ];

    modules.home.coding = {
      enable = true;
      github.enable = true;
      vscodium.enable = true;
      opencode.enable = true;
    };

    modules.home.office = {
      enable = true;
      onlyoffice.enable = true;
    };

    modules.home.persistence = {
      enable = true;
      path = "/persist";
    };

    modules.home.desktop.niri.enable = true;

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

  hardware.ckb-next.enable = true;

  programs.nix-ld.enable = true;

  system.stateVersion = "25.11";
}
