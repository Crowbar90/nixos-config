{ inputs, pkgs, ... }:

{
  imports = [
    ../../modules/home/development
    ../../modules/home/persistence.nix
    ../../modules/home/gaming.nix
    ../../modules/home/photography.nix
    ../../modules/home/desktop/niri.nix
  ];

  # Common development configurations across all hosts
  modules.development = {
    enable = true;
    git = {
      enable = true;
      userName = "Francesco Venturoli";
      userEmail = "f.venturoli@gmail.com";
    };
    github.enable = true;
  };

  # Core applications installed for Francesco on all systems
  home.packages = [
    inputs.antigravity-nix.packages.x86_64-linux.default
    pkgs.chromium
    pkgs.dotnet-sdk_10
    pkgs.nixd
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
