{ ... }:

{
  imports = [
    ./core.nix
    ./desktop/niri.nix
    ./desktop/noctalia.nix
    ./shell/zsh.nix
    ./shell/variables.nix
    ./apps/browsers.nix
    ./apps/development.nix
    ./apps/messaging.nix
    ./apps/terminal.nix
    ./apps/tools.nix
  ];
}
