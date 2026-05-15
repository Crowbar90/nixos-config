{ config, lib, pkgs, ... }:

let
  cfg = config.modules.hardware.graphics.broadwell;
in
{
  options.modules.hardware.graphics.broadwell = {
    enable = lib.mkEnableOption "Intel Broadwell graphics support";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };
}
