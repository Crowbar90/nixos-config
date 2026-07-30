{ config, lib, inputs, ... }:

let
  cfg = config.modules.desktop.niri;
in
{
  options.modules.desktop.niri = {
    enable = lib.mkEnableOption "Niri window manager";
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
    };
  };
}
