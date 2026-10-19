{
  config,
  lib,
  ...
}: let
  cfg = config.modules.ssh-server;
in {
  options.modules.ssh-server = {
    enable = lib.mkEnableOption "SSH server";

    allowUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of allowed users.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = cfg.allowUsers;
        MaxAuthTries = 3;
        PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      };
    };
  };
}
