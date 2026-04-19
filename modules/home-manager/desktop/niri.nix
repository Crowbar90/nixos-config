{ pkgs, ... }:

{
  programs.niri = {
    package = pkgs.niri;
    settings = {
      spawn-at-startup = [
        {
          command = [ "noctalia-shell" ];
        }
      ];
    };
  };
}
