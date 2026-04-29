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

  home.stateVersion = "25.11";
}
