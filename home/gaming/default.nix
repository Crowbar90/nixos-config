{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.gaming;
in {
  options.modules.home.gaming = {
    enable = lib.mkEnableOption "user-level gaming configurations and tools";

    heroic = {
      enable = lib.mkEnableOption "Heroic Game Launcher";
    };

    lutris = {
      enable = lib.mkEnableOption "Lutris Open Gaming Platform";
    };

    mangohud = {
      enable = lib.mkEnableOption "MangoHud";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      []
      ++ (lib.optionals cfg.heroic.enable [heroic]);

    programs.mangohud = lib.mkIf cfg.mangohud.enable {
      enable = true;
      enableSessionWide = true;
    };

    programs.lutris = lib.mkIf cfg.lutris.enable {
      enable = true;
    };
  };
}
