{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.virtualisation;
in {
  options.modules.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation";

    podman = {
      enable = lib.mkEnableOption "Podman";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = lib.mkIf cfg.podman.enable {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs;
      []
      ++ (lib.optionals cfg.podman.enable [podman-tui]);
  };
}
