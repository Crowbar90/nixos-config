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
    inputs.labwc-manager.homeManagerModule
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

    file-manager = lib.mkOption {
      type = lib.types.enum ["nemo"];
      default = "nemo";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.labwc = lib.mkIf (cfg.compositor == "labwc") {
      enable = true;

      config.core.gap = 10;

      config.windowSwitcher = {
        preview = false;
        outlines = true;
      };

      config.keyboard = {
        default = true;
        keybinds = [
          {
            key = "W-space";
            actions = [
              {
                name = "Execute";
                command = "noctalia msg panel-toggle launcher";
              }
            ];
          }
          {
            key = "W-s";
            actions = [
              {
                name = "Execute";
                command = "noctalia msg panel-toggle control-center";
              }
            ];
          }
          {
            key = "W-,";
            actions = [
              {
                name = "Execute";
                command = "noctalia msg settings-toggle";
              }
            ];
          }
          {
            key = "XF86AudioRaiseVolume";
            actions = [
              {
                name = "Execute";
                command = "noctalia msg volume-up";
              }
            ];
          }
          {
            key = "XF86AudioLowerVolume";
            actions = [
              {
                name = "Execute";
                command = "noctalia msg volume-down";
              }
            ];
          }
          {
            key = "XF86AudioMute";
            actions = [
              {
                name = "Execute";
                command = "noctalia msg volume-mute";
              }
            ];
          }
          {
            key = "XF86MonBrightnessUp";
            actions = [
              {
                name = "Execute";
                command = "noctalia msg brightness-up";
              }
            ];
          }
          {
            key = "XF86MonBrightnessDown";
            actions = [
              {
                name = "Execute";
                command = "noctalia msg brightness-down";
              }
            ];
          }
        ];
      };

      autostart = ["noctalia"];
    };

    xdg = lib.mkIf (cfg.file-manager == "nemo") {
      configFile."niri/config.kdl" = lib.mkIf (cfg.compositor == "niri") {
        text = ''
          input {
              keyboard {
                  xkb {
                      layout "it"
                  }
              }
              touchpad {
                  tap
                  natural-scroll
              }
          }

          hotkey-overlay {
              skip-at-startup
          }

          binds {
              "Mod+T" { spawn "${cfg.terminal}"; }
              "Mod+O" { show-hotkey-overlay; }
              "Mod+D" { spawn "${cfg.launcher}"; }
              "Mod+L" { spawn "${cfg.screen-locker}"; }
              "Mod+F" { maximize-column; }
              "Mod+Shift+F" { fullscreen-window; }
          }

          spawn-at-startup "noctalia"

          window-rule {
              geometry-corner-radius 8.0
              clip-to-geometry true
          }

          debug {
              honor-xdg-activation-with-invalid-serial
          }
        '';
      };

      desktopEntries.nemo = {
        name = "Nemo";
        exec = "${pkgs.nemo-with-extensions}/bin/nemo";
      };

      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = ["nemo.desktop"];
          "application/x-gnome-saved-search" = ["nemo.desktop"];
        };
      };
    };

    dconf.settings."org/cinnamon/desktop/applications/terminal".exec = lib.mkIf (cfg.terminal == "kitty") "kitty";

    programs.kitty.enable = lib.mkIf (cfg.terminal == "kitty") true;
    programs.fuzzel.enable = lib.mkIf (cfg.launcher == "fuzzel") true;
    programs.swaylock.enable = lib.mkIf (cfg.screen-locker == "swaylock") true;

    services.mako.enable = lib.mkIf (cfg.notification-daemon == "mako") true;
    services.swayidle.enable = lib.mkIf (cfg.idle-management-daemon == "swayidle") true;
    services.polkit-gnome.enable = true;

    home.packages = with pkgs;
      [
        xwayland-satellite
        noctalia
      ]
      ++ (lib.optionals (cfg.wallpaper == "swaybg") [swaybg]);
  };
}
