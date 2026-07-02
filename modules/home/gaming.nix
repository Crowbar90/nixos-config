{ config, lib, pkgs, ... }:

let
  cfg = config.modules.gaming;
in
{
  options.modules.gaming = {
    enable = lib.mkEnableOption "user-level gaming configurations and tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lutris
      heroic
      mangohud
      piper # gaming mouse configuration GUI
    ];

    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
    };
  };
}
