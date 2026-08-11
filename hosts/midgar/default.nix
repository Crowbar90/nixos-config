{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware.nix
    ../../hardware/graphics/nvidia
    ./disks.nix
    ../../modules/core
    ../../modules/gaming
    ../../modules/obs-studio
    ../../modules/secureboot
    ../../modules/users/francesco
    inputs.impermanence.nixosModules.impermanence
  ];

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

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "midgar";

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

  modules.users.francesco.enable = true;

  users.users.francesco.extraGroups = [ "gamemode" ];

  home-manager.users.francesco = {
    modules.coding = {
      git.enable = true;
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

    modules.gaming = {
      enable = true;
      heroic.enable = false;
      mangohud.enable = true;
    };

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

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
    server.port = 6742;
  };

  programs.nix-ld.enable = true;

  boot.supportedFilesystems = [ "nfs" ];

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
