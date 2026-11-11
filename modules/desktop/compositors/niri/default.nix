{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.compositors.niri;
in {
  options.modules.desktop.compositors.niri.enable = lib.mkEnableOption "the Niri compositor";

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
  };
}
