{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.desktop.shells.noctalia;
  labwc = config.modules.home.desktop.compositors.labwc;
in {
  options.modules.home.desktop.shells.noctalia.enable =
    lib.mkEnableOption "Noctalia keybinds in this user's compositors";

  config = lib.mkIf (cfg.enable && labwc.enable) {
    wayland.windowManager.labwc.rc.keyboard.keybind = lib.mkAfter [
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
}
