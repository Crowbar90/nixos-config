{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.desktop.noctalia;
in {
  options.modules.home.desktop.noctalia = {
    enable = lib.mkEnableOption "Noctalia desktop shell";

    compositors = lib.mkOption {
      type = lib.types.listOf (lib.types.enum ["niri" "labwc"]);
      default = ["niri"];
      description = "Compositors configured for this user; all listed compositors are enabled together.";
    };

    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "it";
      description = "XKB keyboard layout used by the compositor.";
    };

    outputs = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Output connector name, e.g. DP-2 or HDMI-1.";
          };

          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to enable this output.";
          };

          mode = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "1920x1200@60Hz";
            description = "Output mode as <width>x<height>[@<rate>[Hz]].";
          };

          position = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "1920,0";
            description = "Position of the output in the global coordinate space.";
          };

          scale = lib.mkOption {
            type = lib.types.nullOr lib.types.float;
            default = null;
            description = "Output scale factor.";
          };

          transform = lib.mkOption {
            type = lib.types.nullOr (lib.types.enum [
              "normal"
              "90"
              "180"
              "270"
              "flipped"
              "flipped-90"
              "flipped-180"
              "flipped-270"
            ]);
            default = null;
            description = "Output rotation/transform.";
          };
        };
      });
      default = [];
      description = "Output layout applied through kanshi when non-empty.";
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
    wayland.windowManager.labwc = lib.mkIf (builtins.elem "labwc" cfg.compositors) {
      enable = true;
      package = null;

      environment = [
        "XKB_DEFAULT_LAYOUT=${cfg.keyboardLayout}"
      ];

      rc = {
        core.gap = 10;

        windowSwitcher = {
          preview = "no";
          outlines = "yes";
        };

        keyboard = {
          default = true;
          keybind = [
            {
              "@key" = "W-space";
              action = {
                "@name" = "Execute";
                "@command" = "noctalia msg panel-toggle launcher";
              };
            }
            {
              "@key" = "W-s";
              action = {
                "@name" = "Execute";
                "@command" = "noctalia msg panel-toggle control-center";
              };
            }
            {
              "@key" = "W-,";
              action = {
                "@name" = "Execute";
                "@command" = "noctalia msg settings-toggle";
              };
            }
            {
              "@key" = "W-Return";
              action = {
                "@name" = "Execute";
                "@command" = cfg.terminal;
              };
            }
            {
              "@key" = "W-d";
              action = {
                "@name" = "Execute";
                "@command" = cfg.launcher;
              };
            }
            {
              "@key" = "W-l";
              action = {
                "@name" = "Execute";
                "@command" = cfg.screen-locker;
              };
            }
            {
              "@key" = "XF86AudioRaiseVolume";
              action = {
                "@name" = "Execute";
                "@command" = "noctalia msg volume-up";
              };
            }
            {
              "@key" = "XF86AudioLowerVolume";
              action = {
                "@name" = "Execute";
                "@command" = "noctalia msg volume-down";
              };
            }
            {
              "@key" = "XF86AudioMute";
              action = {
                "@name" = "Execute";
                "@command" = "noctalia msg volume-mute";
              };
            }
            {
              "@key" = "XF86MonBrightnessUp";
              action = {
                "@name" = "Execute";
                "@command" = "noctalia msg brightness-up";
              };
            }
            {
              "@key" = "XF86MonBrightnessDown";
              action = {
                "@name" = "Execute";
                "@command" = "noctalia msg brightness-down";
              };
            }
          ];
        };
      };
    };

    wayland.windowManager.niri = lib.mkIf (builtins.elem "niri" cfg.compositors) {
      enable = true;
      package = null;
      systemd.enable = false;
      portalPackage = null;

      settings = {
        input = {
          keyboard.xkb.layout = cfg.keyboardLayout;
          touchpad = {
            tap = {};
            natural-scroll = {};
          };
        };

        hotkey-overlay.skip-at-startup = {};

        binds = {
          "Mod+T".spawn = [cfg.terminal];
          "Mod+O".show-hotkey-overlay = {};
          "Mod+D".spawn = [cfg.launcher];
          "Mod+L".spawn = [cfg.screen-locker];
          "Mod+F".maximize-column = {};
          "Mod+Shift+F".fullscreen-window = {};
        };

        window-rule = {
          geometry-corner-radius = 8.0;
          clip-to-geometry = true;
        };

        debug.honor-xdg-activation-with-invalid-serial = {};
      };
    };

    xdg = lib.mkIf (cfg.file-manager == "nemo") {
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

    services.kanshi = lib.mkIf (cfg.outputs != []) {
      enable = true;
      settings = [
        {
          profile = {
            name = "noctalia";
            outputs =
              map (output: {
                criteria = output.name;
                status =
                  if output.enable
                  then "enable"
                  else "disable";
                inherit (output) mode position scale transform;
              })
              cfg.outputs;
          };
        }
      ];
    };

    home.packages = with pkgs;
      lib.optionals (cfg.file-manager == "nemo") [nemo-with-extensions]
      ++ lib.optionals (cfg.wallpaper == "swaybg") [swaybg];

    systemd.user.targets.labwc-session = lib.mkIf (builtins.elem "labwc" cfg.compositors) {
      Unit.PropagatesStopTo = ["graphical-session.target"];
    };
  };
}
