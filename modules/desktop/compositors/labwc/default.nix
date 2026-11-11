{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.compositors.labwc;
in {
  options.modules.desktop.compositors.labwc.enable = lib.mkEnableOption "the labwc compositor";

  config = lib.mkIf cfg.enable {
    programs.labwc.enable = true;
  };
}
