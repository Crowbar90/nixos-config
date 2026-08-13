{
  config,
  lib,
  ...
}: let
  cfg = config.modules.users.francesco;
in {
  options.modules.users.francesco = {
    enable = lib.mkEnableOption "Francesco's user account";
  };

  config = lib.mkIf cfg.enable {
    users.users.francesco = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      hashedPassword = "$6$35m44XndUk77Ef6Z$enc0ff47i3K1JQxVAJDwzm.mptOyIufdCmWEUrhqRTPpyZ/14SX5CHVQMKaNVRSLpFuCC/SOT03suW1hkuLl91";
    };
  };
}
