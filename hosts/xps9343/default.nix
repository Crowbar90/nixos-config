{ ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/nixos/core.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/impermanence.nix
    ../../modules/nixos/user.nix
  ];

  networking.hostName = "xps9343";
}
