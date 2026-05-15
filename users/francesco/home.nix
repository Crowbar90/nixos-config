{ inputs, pkgs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
    ../../modules/development
  ];

  modules.development = {
    enable = true;
    git = {
      enable = true;
      userName = "Francesco Venturoli";
      userEmail = "f.venturoli@gmail.com";
    };
    github.enable = true;
  };

  home.persistence."/persist" = {
    directories = [
      "Dev"
      "Documents"
      "Downloads"
      "Pictures"
      ".ssh"
      ".local/share"
      ".config/Code"
      ".config/git"
    ];
    files = [
      ".bash_history"
    ];
  };

  programs.niri.settings = {
    input = {
      keyboard.xkb.layout = "it";
      touchpad.tap = true;
    };

    hotkey-overlay.skip-at-startup = true;

    binds = {
      "Mod+T".action.spawn = "kitty";
      "Mod+O".action.show-hotkey-overlay = [ ];
      "Mod+D".action.spawn = "fuzzel";
      "Mod+L".action.spawn = "swaylock"; # blurred-locker
      "Mod+F".action.maximize-column = [ ];
      "Mod+Shift+F".action.fullscreen-window = [ ];
    };

    spawn-at-startup = [
      {
        command = [ "noctalia-shell" ];
      }
    ];

    window-rules = [
      {
        geometry-corner-radius =
          let
            r = 8.0;
          in
          {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
        clip-to-geometry = true;
      }
    ];

    debug = {
      honor-xdg-activation-with-invalid-serial = [ ];
    };
  };

  programs.kitty.enable = true; # terminal, Super+T
  programs.fuzzel.enable = true; # launcher, Super+D
  programs.swaylock.enable = true; # lock, Super+L

  services.mako.enable = true; # notifications
  services.swayidle.enable = true; # idle
  services.polkit-gnome.enable = true;

  home.packages = [
    inputs.antigravity-nix.packages.x86_64-linux.default
    pkgs.chromium
    pkgs.dotnet-sdk_10
    pkgs.piper
    pkgs.swaybg
    pkgs.xwayland-satellite
  ];

  programs.noctalia-shell = {
    enable = true;
  };

  home.stateVersion = "25.11";
}
