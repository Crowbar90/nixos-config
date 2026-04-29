{ inputs, pkgs, ... }:

{
  imports = [
    inputs.niri.homeModules.niri
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
  };

  home.stateVersion = "25.11";
}
