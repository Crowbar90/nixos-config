{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.shells.noctalia;
in {
  options.modules.desktop.shells.noctalia = {
    enable = lib.mkEnableOption "the Noctalia desktop shell";

    recommendedServices = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable Noctalia's recommended services (NetworkManager, Bluetooth,
        UPower and power-profiles-daemon).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      recommendedServices.enable = cfg.recommendedServices;
    };
  };
}
