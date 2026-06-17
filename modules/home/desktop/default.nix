{ config, lib, ... }:

let
  cfg = config.modules.home.desktop;
in
{
  options.modules.home.desktop = {
    enable = lib.mkEnableOption "Desktop environment configuration (Niri)";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.settings = {
      input = {
        keyboard.xkb.layout = "it";
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
          command = [ "noctalia-shell" ];
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
  };
}
