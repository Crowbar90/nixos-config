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
        "Mod+T".action.spawn = "kitty";
        "Mod+O".action.show-hotkey-overlay = [];
        "Mod+D".action.spawn = "fuzzel";
        "Mod+L".action.spawn = "swaylock";
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

    programs.kitty.enable = lib.mkIf (cfg.compositor == "niri") true;
    programs.fuzzel.enable = lib.mkIf (cfg.compositor == "niri") true;
    programs.swaylock.enable = lib.mkIf (cfg.compositor == "niri") true;

    services.mako.enable = lib.mkIf (cfg.compositor == "niri") true;
    services.swayidle.enable = lib.mkIf (cfg.compositor == "niri") true;
    services.polkit-gnome.enable = true;

    home.packages = lib.optionals (cfg.compositor == "niri") [
      pkgs.swaybg
      pkgs.xwayland-satellite
    ];

    programs.noctalia = {
      enable = true;
    };
  };
}
