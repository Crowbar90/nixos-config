{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.desktop.noctalia;
  greeter = cfg.greeter;
in {
  imports = [
    inputs.niri.nixosModules.niri
    {nixpkgs.overlays = [inputs.niri.overlays.niri];}
    inputs.noctalia-greeter.nixosModules.default
  ];

  options.modules.desktop.noctalia = {
    enable = lib.mkEnableOption "Noctalia desktop shell and compositor";
    compositor = lib.mkOption {
      type = lib.types.enum ["niri" "labwc"];
      default = "niri";
    };

    greeter = {
      enable = lib.mkEnableOption "Noctalia Greeter as the graphical login screen";
      users = lib.mkOption {
        type = lib.types.attrsOf (lib.types.enum ["niri" "labwc"]);
        default = {};
        description = "Per-user compositor mapping for the greetd session; users not listed fall back to niri.";
      };
      settings = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Extra greeter.toml settings merged over the module defaults.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = lib.mkIf (cfg.compositor == "niri" || greeter.enable) true;
    programs.labwc.enable = lib.mkIf (cfg.compositor == "labwc" || greeter.enable) true;

    environment.persistence."/persist".directories = lib.mkIf greeter.enable [
      "/var/lib/noctalia-greeter"
      "/var/lib/AccountsService"
    ];

    programs.noctalia-greeter = lib.mkIf greeter.enable {
      enable = true;
      settings =
        lib.recursiveUpdate {
          session.default = "Noctalia";
          keyboard = {
            layout = "it";
            numlock = true;
          };
          idle.timeout = 300;
        }
        greeter.settings;
    };

    environment.systemPackages = let
      labwcUsers = lib.filterAttrs (name: compositor: compositor == "labwc") greeter.users;

      dispatcher = pkgs.writeShellScriptBin "noctalia-user-session" ''
        set -eu
        user="$(id -un)"
        ${lib.concatStringsSep "" (lib.mapAttrsToList (name: _: ''
            if [ "$user" = "${name}" ]; then
              exec ${config.programs.labwc.package}/bin/labwc
            fi
          '')
          labwcUsers)}
        exec ${config.programs.niri.package}/bin/niri-session
      '';

      session-desktop = pkgs.writeTextFile {
        name = "noctalia";
        destination = "/share/wayland-sessions/noctalia.desktop";
        text = ''
          [Desktop Entry]
          Name=Noctalia
          Comment=Noctalia session (per-user compositor)
          Exec=${dispatcher}/bin/noctalia-user-session
          Type=Application
          DesktopNames=Noctalia
        '';
      };
    in
      lib.mkIf greeter.enable [
        dispatcher
        session-desktop
      ];
  };
}
