{ config, lib, pkgs, ... }:

let
  cfg = config.modules.gaming;
in
{
  options.modules.gaming = {
    enable = lib.mkEnableOption "user-level gaming configurations and tools";

    steam = {
      enable = lib.mkEnableOption "Steam client";
    };

    heroic = {
      enable = lib.mkEnableOption "Heroic Game Launcher";
    };

    gamemode = {
      enable = lib.mkEnableOption "Gamemode";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      mangohud
      piper # gaming mouse configuration GUI
    ]
      ++ (lib.optionals cfg.steam.enable [ steam ])
      ++ (lib.optionals cfg.heroic.enable [ heroic ]);

    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
    };
  };
}
