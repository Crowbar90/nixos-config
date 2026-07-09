{ config, lib, inputs, ... }:

let
  cfg = config.modules.desktop.niri;
in
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  options.modules.desktop.niri = {
    enable = lib.mkEnableOption "Niri window manager";
    useBinaryCache = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use the Niri binary cache";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
    };

    niri-flake.cache.enable = cfg.useBinaryCache;
  };
}
