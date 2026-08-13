{ pkgs, ... }:

{
  imports = [
    ../../home/coding
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

  home.stateVersion = "25.11";
}
