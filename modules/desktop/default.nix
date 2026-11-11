{
  config,
  lib,
  ...
}: let
  compositors = config.modules.desktop.compositors;
in {
  imports = [
    ./common
    ./compositors
    ./greeter
    ./shells/noctalia
  ];

  config.modules.desktop.common.enable = lib.mkDefault (
    compositors.niri.enable || compositors.labwc.enable
  );
}
