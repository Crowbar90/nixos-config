{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.obs-studio;
in {
  options.modules.obs-studio = {
    enable = lib.mkEnableOption "OBS Studio support";
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];

      enableVirtualCamera = true;
    };
  };
}
