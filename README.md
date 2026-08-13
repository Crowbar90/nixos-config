# nixos-config

[![PR check](https://github.com/Crowbar90/nixos-config/actions/workflows/pr-check.yml/badge.svg)](https://github.com/Crowbar90/nixos-config/actions/workflows/pr-check.yml)
[![CI](https://github.com/Crowbar90/nixos-config/actions/workflows/ci.yml/badge.svg)](https://github.com/Crowbar90/nixos-config/actions/workflows/ci.yml)

NixOS configuration managed with flakes.

## Adding a new host

1. Create `hosts/<name>/` with `default.nix`, `disks.nix`, `hardware.nix` (last from `nixos-generate-config`).
2. Add an entry in `parts/nixos-configurations/default.nix`:
   ```nix
   <name> = mkHost "<name>" [
     # input modules needed by this host
   ];
   ```
3. In `hosts/<name>/default.nix`, import the modules you need and set the relevant `modules.X.enable = true` options.

## Adding a new user

1. Create `users/<name>/nixos.nix` (copy and edit `users/francesco/nixos.nix`).
2. Create `users/<name>/home.nix` (copy and edit `users/francesco/home.nix`).
3. Add the user's home directory to `parts/nixos-modules/home.nix`:
   ```nix
   users = [
     "francesco"
     "<name>"
   ];
   ```
4. In each host's `default.nix` that should have this user, import `../../users/<name>/nixos.nix` and set `modules.users.<name>.enable = true`.

## CI

- **PR check** (`pr-check.yml`): runs on PRs and pushes to non-main branches. Validates `nix flake check` and `alejandra` formatting.
- **CI** (`ci.yml`): runs on pushes to `main`. Adds per-host dry-run builds.
