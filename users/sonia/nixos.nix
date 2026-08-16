{
  config,
  lib,
  ...
}: let
  cfg = config.modules.users.sonia;
in {
  options.modules.users.sonia = {
    enable = lib.mkEnableOption "Sonia's user account";
  };

  config = lib.mkIf cfg.enable {
    users.users.sonia = {
      isNormalUser = true;
      extraGroups = ["networkmanager"];
      hashedPassword = "$y$j9T$Mc2kZQfPOGEmeanWUJ6AM0$OKrCDtC43cjJfrgrsiIuy.0UyUHZUNF3mpx.4Y8/uD.";
    };
  };
}
