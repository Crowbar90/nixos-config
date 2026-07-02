#{ config, lib, pkgs, ... }:
#
#let
#  cfg = config.modules.desktop.gnome;
#in
#{
#  options.modules.desktop.gnome = {
#    enable = lib.mkEnableOption "GNOME desktop environment configuration";
#  };
#
#  config = lib.mkIf cfg.enable {
#    home.packages = with pkgs; [
#      gnome-tweaks
#      gnome-extension-manager
#    ];
#
#    dconf.settings = {
#      "org/gnome/desktop/interface" = {
#        color-scheme = "prefer-dark";
#        enable-hot-corners = false;
#      };
#      "org/gnome/desktop/wm/preferences" = {
#        button-layout = "appmenu:close,minimize,maximize";
#      };
#    };
#  };
#}
