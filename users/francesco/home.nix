{pkgs, ...}: {
  imports = [
    ../../home/coding
    ../../home/desktop/noctalia
    ../../home/gaming
    ../../home/office
    ../../home/persistence
    ../../home/photography
  ];

  modules.home.coding = {
    enable = true;
    git = {
      userName = "Francesco Venturoli";
      userEmail = "f.venturoli@gmail.com";
    };
  };

  home.packages = [
    pkgs.chromium
    pkgs.nixd
    pkgs.nixfmt
  ];

  modules.home.photography = {
    enable = true;
    darktable.enable = true;
    gimp.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "battery"
        "gh"
        "git"
      ];
      theme = "robbyrussell";
    };
  };

  home.stateVersion = "25.11";
}
