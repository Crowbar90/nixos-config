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
      enable = lib.mkEnableOption "Lutris";
    };

    mangohud = {
      enable = lib.mkEnableOption "MangoHud";
    };

    steam-tinker-launch = {
      enable = lib.mkEnableOption "SteamTinkerLaunch";
    };

    vkbasalt = {
      enable = lib.mkEnableOption "vkBasalt for ReShade on Vulkan games";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      []
      ++ (lib.optionals cfg.heroic.enable [heroic])
      ++ (lib.optionals cfg.lutris.enable [lutris])
      ++ (lib.optionals cfg.steam-tinker-launch.enable [steamtinkerlaunch])
      ++ (lib.optionals cfg.vkbasalt.enable [vkbasalt]);

    programs.mangohud = lib.mkIf cfg.mangohud.enable {
      enable = true;
      enableSessionWide = true;
    };
  };
}
