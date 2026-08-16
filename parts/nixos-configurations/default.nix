{
  inputs,
  self,
  ...
}: let
  mkHost = hostname: extraModules:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules =
        [
          inputs.disko.nixosModules.disko
          inputs.impermanence.nixosModules.impermanence
          self.nixosModules.base
          self.nixosModules.home
          ./../../hosts/${hostname}/hardware.nix
          ./../../hosts/${hostname}/disks.nix
          ./../../hosts/${hostname}/default.nix
        ]
        ++ extraModules;
    };
in {
  flake.nixosConfigurations = {
    midgar = mkHost "midgar" [
      inputs.lanzaboote.nixosModules.lanzaboote
    ];

    latitude7420 = mkHost "latitude7420" [];

    xps9343 = mkHost "xps9343" [];
  };
}
