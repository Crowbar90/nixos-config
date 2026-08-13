{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.office;
in
{
  options.modules.office = {
    enable = lib.mkEnableOption "Office suite";

    onlyoffice = {
      enable = lib.mkEnableOption "OnlyOffice";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.onlyoffice = lib.mkIf cfg.onlyoffice.enable {
      enable = true;
    };
  };
}
