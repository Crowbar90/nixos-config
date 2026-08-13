{lib, ...}: {
  flake.nixosModules.base = {...}: {
    imports = [
      ./../../modules/base
    ];
  };
}
