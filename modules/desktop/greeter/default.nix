{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.greeter;
in {
  options.modules.desktop.greeter = {
    enable = lib.mkEnableOption "a graphical login greeter";

    kind = lib.mkOption {
      type = lib.types.enum ["noctalia-greeter"];
      default = "noctalia-greeter";
      description = ''
        Greeter implementation. Supporting another greeter means adding a
        value here and a matching branch in the configuration below.
      '';
    };

    defaultSession = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "niri";
      description = "Session pre-selected by the greeter.";
    };

    keyboard = {
      layout = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "XKB layout used by the greeter.";
      };

      numlock = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable numlock in the greeter.";
      };
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Extra settings merged over the defaults of the selected greeter.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.defaultSession =
      lib.mkIf (cfg.defaultSession != null)
      cfg.defaultSession;

    environment.persistence."/persist".directories =
      ["/var/lib/AccountsService"]
      ++ lib.optional (cfg.kind == "noctalia-greeter") "/var/lib/noctalia-greeter";

    services.displayManager.noctalia-greeter = lib.mkIf (cfg.kind == "noctalia-greeter") {
      enable = true;
      settings =
        lib.recursiveUpdate (
          lib.recursiveUpdate {
            keyboard = {
              inherit (cfg.keyboard) layout numlock;
            };
            idle.timeout = 300;
          } (lib.optionalAttrs (cfg.defaultSession != null) {
            session.default = cfg.defaultSession;
          })
        )
        cfg.settings;
    };
  };
}
