{ pkgs, ... }:

{
  # Enable Noctalia/Niri (Install niri package)
  programs.niri.enable = true;

  # Display Manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Theme = {
        CursorTheme = "Adwaita";
      };
    };
  };

  # Essential services for GTK apps and Nemo
  services.gvfs.enable = true;
  programs.dconf.enable = true;

  # XDG Portal
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [
      "gtk"
      "gnome"
    ];
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    flameshot
    git
    grim
    rsync
    sops
    ssh-to-age
    vim
    wget
    wl-clipboard
  ];
}
