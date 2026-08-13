{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.gaming;
in {
  options.modules.gaming = {
    enable = lib.mkEnableOption "system-level gaming configurations and tools";

    steam = {
      enable = lib.mkEnableOption "Steam client";
    };

    gamemode = {
      enable = lib.mkEnableOption "Gamemode";
    };

    hardware = {
      logitech = lib.mkEnableOption "Logitech hardware";
      xbox360 = lib.mkEnableOption "Xbox 360 controller";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules =
      []
      ++ (lib.optionals cfg.hardware.xbox360 ["xpad"]);

    hardware.steam-hardware = lib.mkIf cfg.hardware.xbox360 {
      enable = true;
    };

    programs.steam = lib.mkIf cfg.steam.enable {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    programs.gamemode = lib.mkIf cfg.gamemode.enable {
      enable = true;
    };

    services.ratbagd = lib.mkIf cfg.hardware.logitech {
      enable = true;
    };

    services.udev.packages =
      []
      ++ (lib.optionals cfg.hardware.xbox360 [pkgs.game-devices-udev-rules]);

    environment.systemPackages = with pkgs;
      []
      ++ (lib.optionals cfg.hardware.logitech [piper]);
  };
}
