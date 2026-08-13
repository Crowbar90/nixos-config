{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.home.desktop.niri;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.modules.home.desktop.niri = {
    enable = lib.mkEnableOption "Niri window manager + Noctalia shell";
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config = {
        niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
      };
    };

    programs.niri.settings = {
      input = {
        keyboard.xkb.layout = "it";
        touchpad.tap = true;
      };

      hotkey-overlay.skip-at-startup = true;

      binds = {
        "Mod+T".action.spawn = "kitty";
        "Mod+O".action.show-hotkey-overlay = [ ];
        "Mod+D".action.spawn = "fuzzel";
        "Mod+L".action.spawn = "swaylock";
        "Mod+F".action.maximize-column = [ ];
        "Mod+Shift+F".action.fullscreen-window = [ ];
      };

      spawn-at-startup = [
        {
          command = [ "noctalia" ];
        }
      ];

      window-rules = [
        {
          geometry-corner-radius =
            let
              r = 8.0;
            in
            {
              top-left = r;
              top-right = r;
              bottom-left = r;
              bottom-right = r;
            };
          clip-to-geometry = true;
        }
      ];

      debug = {
        honor-xdg-activation-with-invalid-serial = [ ];
      };
    };

    programs.kitty.enable = true;
    programs.fuzzel.enable = true;
    programs.swaylock.enable = true;

    services.mako.enable = true;
    services.swayidle.enable = true;
    services.polkit-gnome.enable = true;

    home.packages = [
      pkgs.swaybg
      pkgs.xwayland-satellite
    ];

    programs.noctalia = {
      enable = true;
    };
  };
}
