{ pkgs, ... }:

{
  imports = [
    ../../modules/home/coding
    ../../modules/home/persistence.nix
    ../../modules/home/gaming.nix
    ../../modules/home/photography.nix
  ];

  # Common coding configurations across all hosts
  modules.coding = {
    enable = true;
    git = {
      userName = "Francesco Venturoli";
      userEmail = "f.venturoli@gmail.com";
    };
  };

  # Core applications installed for Francesco on all systems
  home.packages = [
    pkgs.chromium
    pkgs.nixd
    pkgs.nixfmt
  ];

  modules.gaming = {
    enable = true;
    steam.enable = true;
    heroic.enable = true;
    gamemode.enable = true;
  };

  modules.photography = {
    enable = true;
    darktable.enable = true;
    gimp.enable = true;
  };

  home.stateVersion = "25.11";
}
