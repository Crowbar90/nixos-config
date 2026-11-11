{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.desktop.compositors.labwc;
  desktop = config.modules.home.desktop;
  apps = desktop.apps;

  outputCommand = output:
    if !output.enable
    then "wlr-randr --output '${output.name}' --off"
    else
      "wlr-randr --output '${output.name}' --on"
      + lib.optionalString (output.mode != null) " --mode ${output.mode}"
      + lib.optionalString (output.position != null)
      " --pos ${toString output.position.x},${toString output.position.y}"
      + lib.optionalString (output.scale != null) " --scale ${toString output.scale}"
      + lib.optionalString (output.transform != null) " --transform ${output.transform}";

  primaryOutputs = lib.filter (output: output.enable && output.primary) desktop.outputs;

  primaryCommand = output: "xrandr --output '${output.name}' --primary";
in {
  options.modules.home.desktop.compositors.labwc.enable =
    lib.mkEnableOption "labwc for this user";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.labwc = {
      enable = true;
      package = null;

      environment = [
        "XKB_DEFAULT_LAYOUT=${desktop.keyboard.layout}"
      ];

      autostart = map outputCommand desktop.outputs ++ map primaryCommand primaryOutputs;

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
              "@key" = "W-Return";
              action = {
                "@name" = "Execute";
                "@command" = apps.terminal;
              };
            }
            {
              "@key" = "W-d";
              action = {
                "@name" = "Execute";
                "@command" = apps.launcher;
              };
            }
            {
              "@key" = "W-l";
              action = {
                "@name" = "Execute";
                "@command" = apps.screenLocker;
              };
            }
          ];
        };
      };
    };

    home.packages =
      lib.optionals (desktop.outputs != []) [pkgs.wlr-randr]
      ++ lib.optionals (primaryOutputs != []) [pkgs.xorg.xrandr];

    systemd.user.targets.labwc-session = {
      Unit.PropagatesStopTo = ["graphical-session.target"];
    };
  };
}
