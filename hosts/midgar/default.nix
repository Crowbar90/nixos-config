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
    ../../modules/ssh-server
    ../../modules/virtualisation
    ../../shares/tower
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
    sunshine.enable = true;
  };

  modules.obs-studio.enable = true;

  modules.users.francesco.enable = true;

  modules.ssh-server = {
    enable = true;
    allowUsers = ["francesco"];
    passwordAuthentication.enable = true;
  };

  modules.virtualisation = {
    enable = true;
    podman.enable = true;
  };

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

  users.users.francesco.extraGroups = ["gamemode" "podman" "docker" "video" "uinput"];

  home-manager.users.francesco = {
    modules.home.coding = {
      enable = true;
      github.enable = true;
      dotnet.enable = true;
      vscodium.enable = true;
      opencode = {
        enable = true;
        desktop.enable = true;
      };
    };

    modules.home.gaming = {
      enable = true;
      lutris.enable = true;
      mangohud.enable = true;
      steam-tinker-launch.enable = true;
      vkbasalt.enable = true;
    };

    modules.home.persistence = {
      enable = true;
      path = "/persist";
    };
  };

  services.xserver.enable = true;
  services.xserver.xkb.layout = "it";

  services.displayManager = {
    gdm.enable = true;
    autoLogin = {
      enable = true;
      user = "francesco";
    };
  };

  services.desktopManager.gnome.enable = true;

  systemd.user.services.lock-after-autologin = {
    description = "Lock GNOME screen immediately after autologin";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 1.5";
      ExecStart = "${pkgs.dbus}/bin/dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock";
    };
  };

  hardware.uinput.enable = true;

  environment.systemPackages = [pkgs.gnome-randr];

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

  shares.tower = {
    darktable.enable = true;
    francesco.enable = true;
  };

  system.stateVersion = "26.05";
}
