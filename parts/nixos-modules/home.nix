{ inputs, ... }:

let
  # List of user directories containing a home.nix.
  # Each user gets auto-wired into home-manager.users.<name>.
  # When you add a new user, add a new entry below.
  users = [
    "francesco"
  ];

  mkUserModule = name: ./../../users/${name}/home.nix;
in
{
  flake.nixosModules.home = { ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };

      users = builtins.listToAttrs (map
        (name: {
          name = name;
          value = { imports = [ (mkUserModule name) ]; };
        })
        users);
    };
  };
}
