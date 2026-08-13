# AGENTS.md

NixOS configurations managed with flakes + flake-parts, home-manager for users, disko + impermanence for storage. One repo, three hosts: `midgar`, `latitude7420`, `xps9343`.

## Commands

The flake declares **no `formatter` output**, so `nix fmt` fails. Use these instead (match CI exactly).

- Format check: `nix run nixpkgs#alejandra -- --check .`
- Format fix: `nix run nixpkgs#alejandra -- .`
- Type/eval check: `nix flake check --no-build --all-systems`
- Per-host dry build (matches CI): `nix build .#nixosConfigurations.<host>.config.system.build.toplevel --dry-run`

CI order on every change: alejandra -> `flake check` -> per-host dry build. Do not run `nixos-rebuild switch` from an agent context.

`pkgs.nixfmt` is installed on this user but it is not the project formatter. Alejandra is.

## Workflow

- Work on a feature branch, open a PR to `main`. `pr-check.yml` runs on `pull_request`; `ci.yml` runs on push to `main` and adds the dry-run build matrix.
- When adding a host, also add it to the matrix in `.github/workflows/ci.yml`.
- Use a git worktree for implementation. Planning in the main checkout is fine, but create a worktree before making changes and remove it after the user confirms the session is done.

## Architecture (read this before editing)

- `flake.nix` imports `parts/nixos-modules/base.nix`, `parts/nixos-modules/home.nix`, `parts/nixos-configurations/`. That last one defines the `nixosConfigurations` and is the only place to register hosts.
- Host assembly lives in `mkHost` (`parts/nixos-configurations/default.nix`). It auto-injects: `disko`, `impermanence`, `nixosModules.base`, `nixosModules.home`, plus the host's `hardware.nix`, `disks.nix`, `default.nix`. Pass flake-input-specific modules (e.g. `lanzaboote`, `niri`) in the `extraModules` list.
- niri hosts must pass **both** `inputs.niri.nixosModules.niri` and `{nixpkgs.overlays = [inputs.niri.overlays.niri];}`. See `latitude7420`/`xps9343` for the pattern.
- Users are wired into home-manager by the list in `parts/nixos-modules/home.nix`. Adding `users/<n>/home.nix` alone does nothing; the name must be in that list.
- Two-layer module namespace: `modules/*` = NixOS options under `modules.*`; `home/*` = home-manager options under `modules.home.*`. Hosts set home options inside a `home-manager.users.<name> = { ... }` block (see any host's `default.nix`).

## Module conventions

- Pattern: `cfg = config.modules.<path>`; declare `options.modules.<path>` with `lib.mkEnableOption`; wrap the body in `lib.mkIf cfg.enable`.
- Sub-features are nested `enable` flags aggregated via `lib.optionals`, e.g. `modules.home.coding`, `modules.gaming`.
- Hosts double-import `./hardware.nix` and `./disks.nix` even though `mkHost` already adds them. Harmless; keep the pattern for consistency.

## Impermanence gotchas

- `/persist` is the root; the mountpoint and `neededForBoot = true` are set in each host's `disks.nix` for `/persist`, `/home`, `/var/log`.
- System state belongs in `environment.persistence."/persist"` (see any host `default.nix`). User state belongs in `modules.home.persistence` (`home/persistence/default.nix` lists known dirs/files). Anything not listed is wiped on reboot.

## Known landmines

- `overlays/` (`ckb-next.nix`, `openldap.nix`) is **not imported anywhere**. `hardware.ckb-next.enable = true` resolves to plain nixpkgs. Edits to files in `overlays/` have zero effect until wired into `nixpkgs.overlays`.
- `users/francesco/nixos.nix` contains a plaintext `hashedPassword`. `.gitignore` reserves `secrets/*.dec` for future secret handling; do not commit decrypted secrets.
- `system.stateVersion` differs per host on purpose (`midgar = "26.05"`, `latitude7420 = "25.11"`, `xps9343 = "25.11"`). Never normalize them.

## Adding things

For the host/user onboarding steps, follow `README.md` ("Adding a new host", "Adding a new user"). Update both `parts/nixos-configurations/default.nix` and the user list in `parts/nixos-modules/home.nix` when applicable.
