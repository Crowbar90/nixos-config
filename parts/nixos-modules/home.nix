{inputs, ...}: let
  # List of user directories containing a home.nix.
  # Each user gets auto-wired into home-manager.users.<name>,
  # but only on hosts where the NixOS user module has enable = true.
  users = [
    "francesco"
    "sonia"
  ];

  mkUserModule = name: ./../../users/${name}/home.nix;
in {
  flake.nixosModules.home = {config, ...}: let
    # Only wire users that are enabled on this host via modules.users.<name>.enable.
    enabledUsers = builtins.filter (name: (config.modules.users.${name} or {}).enable or false) users;
  in {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};

      users = builtins.listToAttrs (map
        (name: {
          name = name;
          value = {imports = [(mkUserModule name)];};
        })
        enabledUsers);
    };
  };
}
