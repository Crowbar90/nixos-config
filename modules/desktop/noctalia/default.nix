{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.desktop.noctalia;
in {
  imports = [
    inputs.niri.nixosModules.niri
    {nixpkgs.overlays = [inputs.niri.overlays.niri];}
  ];

  options.modules.desktop.noctalia = {
    enable = lib.mkEnableOption "Noctalia desktop shell and compositor";
    compositor = lib.mkOption {
      type = lib.types.enum ["niri" "labwc"];
      default = "niri";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = lib.mkIf (cfg.compositor == "niri") true;
  };
}
