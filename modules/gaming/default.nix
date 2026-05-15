{ config, lib, ... }:

let
  cfg = config.modules.gaming;
in
{
  options.modules.gaming = {
    enable = lib.mkEnableOption "gaming support";

    steam = {
      enable = lib.mkEnableOption "Steam";
    };

    gamemode = {
      enable = lib.mkEnableOption "Gamemode";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.steam = lib.mkIf cfg.steam.enable {
      enable = true;
    };

    programs.gamemode = lib.mkIf cfg.gamemode.enable {
      enable = true;
    };
  };
}
