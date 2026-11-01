{
  config,
  lib,
  ...
}: let
  cfg = config.shares.tower;
in {
  options.shares.tower = {
    darktable = {
      enable = lib.mkEnableOption "/mnt/tower/darktable";
    };

    francesco = {
      enable = lib.mkEnableOption "/mnt/tower/darktable";
    };
  };

  config = {
    fileSystems."/mnt/tower/darktable" = lib.mkIf cfg.darktable.enable {
      device = "192.168.40.2:/mnt/user/darktable";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
      ];
    };

    fileSystems."/mnt/tower/francesco" = lib.mkIf cfg.francesco.enable {
      device = "192.168.40.2:/mnt/user/francesco";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
      ];
    };
  };
}
