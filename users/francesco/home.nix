{ inputs, pkgs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.persistence."/persist" = {
    directories = [
      "Dev"
      "Documents"
      "Downloads"
      "Pictures"
      ".ssh"
      ".local/share/keyrings"
      ".config/Code"
      ".config/git"
    ];
    files = [
      ".bash_history"
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Francesco Venturoli";
        email = "f.venturoli@gmail.com";
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
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
    pkgs.chromium
    pkgs.swaybg
  ];

  programs.noctalia-shell = {
    enable = true;
  };

  home.stateVersion = "25.11";
}
