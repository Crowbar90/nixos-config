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
    ../../modules/printing
    ../../modules/virtualisation
    ../../modules/desktop
    ../../shares/tower
    ../../users/francesco/nixos.nix
    ../../users/sonia/nixos.nix
  ];

  networking.hostName = "latitude7420";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vpl-gpu-rt
      libva
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.kernelModules = [
    "kvm-intel"
    "i915"
    "v4l2loopback"
  ];
  boot.kernelParams = [
    "i915.enable_guc=3"
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
  '';

  modules.desktop = {
    compositors = {
      niri.enable = true;
      labwc.enable = true;
    };

    shells.noctalia = {
      enable = true;
      # TLP manages power on this laptop; power-profiles-daemon would conflict.
      recommendedServices = false;
    };

    greeter = {
      enable = true;
      defaultSession = "niri";
      keyboard.layout = "it";
      settings = {
        user.default = "francesco";
        output = {
          width = 1920;
          height = 1080;
          scale = 1;
        };
      };
    };
  };

  modules.gaming = {
    enable = true;
    steam.enable = true;
    gamemode.enable = true;
    hardware.logitech = true;
    hardware.xbox360 = true;
  };

  modules.users.francesco.enable = true;
  modules.users.sonia.enable = true;

  modules.virtualisation = {
    enable = true;
    podman.enable = true;
  };

  modules.obs-studio.enable = true;

  modules.printing = {
    enable = true;
    epson-escpr2.enable = true;
  };

  users.users.francesco.extraGroups = ["gamemode"];
  users.users.francesco.shell = pkgs.zsh;

  home-manager.users.francesco = {
    modules.home.coding = {
      enable = true;
      dotnet.enable = true;
      github.enable = true;
      vscodium.enable = true;
      opencode.enable = true;
      jetbrains = {
        toolbox.enable = false;
        rider.enable = true;
      };
    };

    modules.home.gaming = {
      enable = true;
      mangohud.enable = true;
      heroic.enable = false;
      lutris.enable = true;
      steam-tinker-launch.enable = true;
      vkbasalt.enable = true;
    };

    modules.home.office = {
      enable = true;
      onlyoffice.enable = true;
    };

    modules.home.persistence = {
      enable = true;
      path = "/persist";
    };

    modules.home.desktop = {
      keyboard.layout = "it";
      apps.enable = true;
      compositors = {
        niri.enable = true;
        labwc.enable = true;
      };
      shells.noctalia.enable = true;

      outputs = [
        {
          name = "eDP-1";
          mode = "1920x1080";
          scale = 1.0;
        }
      ];
    };

    home.packages = with pkgs; [
      calibre
    ];
  };

  home-manager.users.sonia = {
    modules.home.coding = {
      enable = false;
    };

    modules.home.gaming = {
      enable = true;
      mangohud.enable = false;
      heroic.enable = false;
      lutris.enable = true;
      steam-tinker-launch.enable = false;
      vkbasalt.enable = false;
    };

    modules.home.office = {
      enable = true;
      onlyoffice.enable = true;
    };

    modules.home.persistence = {
      enable = true;
      path = "/persist";
    };

    modules.home.desktop = {
      keyboard.layout = "it";
      apps.enable = true;
      compositors = {
        niri.enable = true;
        labwc.enable = true;
      };
      shells.noctalia.enable = true;

      outputs = [
        {
          name = "eDP-1";
          mode = "1920x1080";
          scale = 1.0;
        }
      ];
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

  programs.nix-ld.enable = true;

  programs.zsh.enable = true;

  boot.supportedFilesystems = ["nfs"];

  shares.tower = {
    darktable.enable = true;
    francesco.enable = true;
  };

  system.stateVersion = "25.11";
}
