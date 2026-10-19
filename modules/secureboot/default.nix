{pkgs, ...}: {
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
    configurationLimit = 5;
  };

  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
