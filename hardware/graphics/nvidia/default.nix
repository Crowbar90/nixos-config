{ config, lib, pkgs, ... }:

let
  cfg = config.modules.hardware.graphics.nvidia;
in
{
  options.modules.hardware.graphics.nvidia = {
    enable = lib.mkEnableOption "Nvidia graphics support";
    open = lib.mkEnableOption "Open-source kernel module";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
    };

    hardware.nvidia.open = cfg.open;

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
