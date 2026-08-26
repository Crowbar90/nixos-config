{
  config,
  lib,
  ...
}: let
  cfg = config.modules.coding;
in {
  options.modules.coding = {
    enable = lib.mkEnableOption "system-level coding configurations and tools";

    docker = {
      enable = lib.mkEnableOption "Docker daemon";
    };
  };

  config = lib.mkIf cfg.enable {

    virtualisation.docker = lib.mkIf cfg.docker.enable {
      enable = true;
      daemon.settings.experimental = true;
    };
  };
}
