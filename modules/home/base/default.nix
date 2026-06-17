{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.modules.home.base;
in
{
  options.modules.home.base = {
    enable = lib.mkEnableOption "Base home configuration with Noctalia shell";
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
    };

    programs.kitty.enable = true;      # terminal, Super+T
    programs.fuzzel.enable = true;      # launcher, Super+D
    programs.swaylock.enable = true;    # lock, Super+L

    services.mako.enable = true;        # notifications
    services.swayidle.enable = true;    # idle
    services.polkit-gnome.enable = true;

    home.packages = [
      inputs.antigravity-nix.packages.x86_64-linux.default
      pkgs.chromium
      pkgs.swaybg
      pkgs.xwayland-satellite
    ];
  };
}
