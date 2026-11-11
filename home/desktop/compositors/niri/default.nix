{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.desktop.compositors.niri;
  desktop = config.modules.home.desktop;
  apps = desktop.apps;

  outputNode = output:
    if output.enable
    then {
      output =
        {_args = [output.name];}
        // lib.optionalAttrs (output.mode != null) {inherit (output) mode;}
        // lib.optionalAttrs (output.scale != null) {inherit (output) scale;}
        // lib.optionalAttrs (output.transform != null) {inherit (output) transform;}
        // lib.optionalAttrs (output.position != null) {
          position._props = {
            inherit (output.position) x y;
          };
        };
    }
    else {
      output = {
        _args = [output.name];
        off = {};
      };
    };
in {
  options.modules.home.desktop.compositors.niri.enable =
    lib.mkEnableOption "Niri for this user";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.niri = {
      enable = true;
      package = null;
      systemd.enable = false;
      portalPackage = null;

      settings = {
        _children = map outputNode desktop.outputs;

        input = {
          keyboard.xkb.layout = desktop.keyboard.layout;
          touchpad = {
            tap = {};
            natural-scroll = {};
          };
        };

        hotkey-overlay.skip-at-startup = {};

        binds = {
          "Mod+T".spawn = [apps.terminal];
          "Mod+O".show-hotkey-overlay = {};
          "Mod+D".spawn = [apps.launcher];
          "Mod+L".spawn = [apps.screenLocker];
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
  };
}
