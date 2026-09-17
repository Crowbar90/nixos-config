{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hardware.graphics.nvidia;
in {
  options.modules.hardware.graphics.nvidia = {
    enable = lib.mkEnableOption "Nvidia graphics support";
    open = lib.mkEnableOption "Open-source kernel module";
    useBinaryCache = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use the NixOS CUDA binary cache";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };

    hardware.nvidia = {
      modesetting.enable = true;
      open = cfg.open;
      nvidiaSettings = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    nix.settings = lib.mkIf cfg.useBinaryCache {
      substituters = ["https://cache.nixos-cuda.org"];
      trusted-public-keys = ["cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="];
    };
  };
}
