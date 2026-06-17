{ config, lib, ... }:

let
  cfg = config.modules.home.laptop;
in
{
  options.modules.home.laptop = {
    enable = lib.mkEnableOption "Laptop-specific home configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.settings = {
      input = {
        touchpad.tap = true;
      };
    };
  };
}
