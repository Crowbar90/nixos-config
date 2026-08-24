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
    ../../users/sonia/nixos.nix
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

  modules.desktop.noctalia.enable = true;
  modules.users.francesco.enable = true;
  modules.users.sonia.enable = true;

  modules.obs-studio.enable = true;

  programs.xwayland.enable = true;
  security.polkit.enable = true;

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

    modules.home.office = {
      enable = true;
      onlyoffice.enable = true;
    };

    modules.home.persistence = {
      enable = true;
      path = "/persist";
    };

    modules.home.desktop.noctalia = {
      enable = true;
      compositor = "niri";
      terminal = "kitty";
      launcher = "fuzzel";
      screen-locker = "swaylock";
      notification-daemon = "mako";
      idle-management-daemon = "swayidle";
      wallpaper = "swaybg";
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

  home-manager.users.sonia = {
    imports = [
      ../../home/desktop/noctalia
    ];

    modules.home.coding = {
      enable = false;
    };

    modules.home.office = {
      enable = true;
      onlyoffice.enable = true;
    };

    modules.home.persistence = {
      enable = true;
      path = "/persist";
    };

    modules.home.desktop.noctalia = {
      enable = true;
      compositor = "labwc";
      terminal = "kitty";
      launcher = "fuzzel";
      screen-locker = "swaylock";
      notification-daemon = "mako";
      idle-management-daemon = "swayidle";
      wallpaper = "swaybg";
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

  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  hardware.ckb-next.enable = true;

  programs.nix-ld.enable = true;

  boot.supportedFilesystems = ["nfs"];

  fileSystems."/mnt/tower/francesco" = {
    device = "192.168.40.2:/mnt/user/francesco";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  system.stateVersion = "25.11";
}
