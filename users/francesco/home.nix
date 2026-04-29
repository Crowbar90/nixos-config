{ inputs, pkgs, ... }:

{
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
  };

  programs.kitty.enable = true; # terminal, Super+T
  programs.fuzzel.enable = true; # launcher, Super+D
  programs.swaylock.enable = true; # lock, Super+L

  services.mako.enable = true; # notifications
  services.swayidle.enable = true; # idle
  services.polkit-gnome.enable = true;

  home.packages = [
    pkgs.swaybg
  ];

  home.stateVersion = "25.11";
}
