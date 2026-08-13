{ pkgs, ... }:

{
  imports = [
    ../../modules/home/coding
    ../../modules/home/gaming.nix
    ../../modules/home/office
    ../../modules/home/persistence.nix
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

  modules.photography = {
    enable = true;
    darktable.enable = true;
    gimp.enable = true;
  };

  home.stateVersion = "25.11";
}
