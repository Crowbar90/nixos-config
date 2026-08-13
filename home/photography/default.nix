{ config, lib, pkgs, ... }:

let
  cfg = config.modules.home.photography;
in
{
  options.modules.home.photography = {
    enable = lib.mkEnableOption "user-level photography configurations and tools";

    darktable = {
      enable = lib.mkEnableOption "Darktable";
    };

    gimp = {
      enable = lib.mkEnableOption "Gimp";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      (lib.optionals cfg.darktable.enable [ darktable ]) ++
      (lib.optionals cfg.gimp.enable [ gimp ]);
  };
}
