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
      hashedPassword = "$y$j9T$jvfR1WiKqHoJErQ8DaO67/$gzz7qCSbOIch4wWb0eb.yw7JlnXGSqmC6kv8K6TCsC3";
    };
  };
}
