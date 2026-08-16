{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.home.desktop.noctalia;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.modules.home.desktop.noctalia = {
    enable = lib.mkEnableOption "Noctalia desktop shell";

    compositor = lib.mkOption {
      type = lib.types.enum ["niri" "labwc"];
      default = "niri";
    };

    terminal = lib.mkOption {
      type = lib.types.enum ["kitty"];
      default = "kitty";
    };

    launcher = lib.mkOption {
      type = lib.types.enum ["fuzzel"];
      default = "fuzzel";
    };

    screen-locker = lib.mkOption {
      type = lib.types.enum ["swaylock"];
      default = "swaylock";
    };

    notification-daemon = lib.mkOption {
      type = lib.types.enum ["mako"];
      default = "mako";
    };

    idle-management-daemon = lib.mkOption {
      type = lib.types.enum ["swayidle"];
      default = "swayidle";
    };

    wallpaper = lib.mkOption {
      type = lib.types.enum ["swaybg"];
      default = "swaybg";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config = lib.mkIf (cfg.compositor == "niri") {
        niri = {
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        };
      };
    };

    programs.niri.settings = lib.mkIf (cfg.compositor == "niri") {
      input = {
        keyboard.xkb.layout = "it";
        touchpad.tap = true;
      };

      hotkey-overlay.skip-at-startup = true;

      binds = {
        "Mod+T".action.spawn =
          {
            "kitty" = "kitty";
          }."${cfg.terminal}";

        "Mod+O".action.show-hotkey-overlay = [];

        "Mod+D".action.spawn =
          {
            "fuzzel" = "fuzzel";
          }."${cfg.launcher}";

        "Mod+L".action.spawn =
          {
            "swaylock" = "swaylock";
          }."${cfg.screen-locker}";

        "Mod+F".action.maximize-column = [];

        "Mod+Shift+F".action.fullscreen-window = [];
      };

      spawn-at-startup = [
        {
          command = ["noctalia"];
        }
      ];

      window-rules = [
        {
          geometry-corner-radius = let
            r = 8.0;
          in {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
          clip-to-geometry = true;
        }
      ];

      debug = {
        honor-xdg-activation-with-invalid-serial = [];
      };
    };

    programs.kitty.enable = lib.mkIf (cfg.terminal == "kitty") true;
    programs.fuzzel.enable = lib.mkIf (cfg.launcher == "fuzzel") true;
    programs.swaylock.enable = lib.mkIf (cfg.screen-locker == "swaylock") true;

    services.mako.enable = lib.mkIf (cfg.notification-daemon == "mako") true;
    services.swayidle.enable = lib.mkIf (cfg.idle-management-daemon == "swayidle") true;
    services.polkit-gnome.enable = true;

    home.packages = with pkgs;
      [
        xwayland-satellite
      ]
      ++ (lib.optionals (cfg.wallpaper == "swaybg") [swaybg]);

    programs.noctalia = {
      enable = true;
    };
  };
}
