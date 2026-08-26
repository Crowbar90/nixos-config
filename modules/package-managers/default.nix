{
  config,
  lib,
  ...
}: let
  cfg = config.modules.package-managers;
in {
  options.modules.package-managers = {
    flatpak = {
      enable = lib.mkEnableOption "Flatpak";
    };
  };

  config = {
    services.flatpak = lib.mkIf cfg.flatpak.enable {
      enable = true;
    };
  };
}
