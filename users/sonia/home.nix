{pkgs, ...}: {
  imports = [
    ../../home/coding
    ../../home/desktop/noctalia
    ../../home/gaming
    ../../home/office
    ../../home/persistence
    ../../home/photography
  ];

  home.packages = [
    pkgs.chromium
  ];

  home.stateVersion = "25.11";
}
