{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./disks.nix
    ../../hardware/graphics/nvidia
    ../../modules/gaming
    ../../modules/obs-studio
    ../../modules/secureboot
    ../../users/francesco/nixos.nix
  ];

  networking.hostName = "midgar";

  nixpkgs.config.allowUnfree = true;

  modules.hardware.graphics.nvidia = {
    enable = true;
    open = true;
    useBinaryCache = true;
  };
  modules.gaming = {
    enable = true;
    steam.enable = true;
    gamemode.enable = true;
    hardware.logitech = true;
    hardware.xbox360 = true;
  };
  modules.obs-studio.enable = true;

  modules.users.francesco.enable = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/secureboot"
      "/var/lib/sbctl"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableRedistributableFirmware = true;

  users.users.francesco.extraGroups = ["gamemode"];

  home-manager.users.francesco = {
    modules.home.coding = {
      enable = true;
      github.enable = true;
      dotnet.enable = true;
      antigravity = {
        enable = true;
        ide.enable = true;
        cli.enable = true;
      };
      vscodium.enable = true;
      opencode = {
        enable = true;
        desktop.enable = true;
      };
    };

    modules.home.gaming = {
      enable = true;
      mangohud.enable = true;
    };

    modules.home.persistence = {
      enable = true;
      path = "/persist";
    };
  };

  services.xserver.enable = true;
  services.xserver.xkb.layout = "it";

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.ckb-next.enable = true;

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
    server.port = 6742;
  };

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

  system.stateVersion = "26.05";
}
