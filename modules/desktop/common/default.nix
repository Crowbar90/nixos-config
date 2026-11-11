{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.common;
in {
  options.modules.desktop.common.enable = lib.mkEnableOption "services shared by any desktop session";

  config = lib.mkIf cfg.enable {
    services.gvfs.enable = lib.mkDefault true;
    services.udisks2.enable = lib.mkDefault true;
    services.udisks2.mountOnMedia = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;
  };
}
