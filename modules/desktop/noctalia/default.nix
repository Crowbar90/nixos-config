{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.noctalia;
  greeter = cfg.greeter;

  sessionCompositors =
    if greeter.compositors == []
    then [cfg.compositor]
    else lib.unique greeter.compositors;

  wantedCompositors = lib.unique ([cfg.compositor] ++ sessionCompositors);

  niriEnabled = builtins.elem "niri" wantedCompositors;
  labwcEnabled = builtins.elem "labwc" wantedCompositors;

  compositorCommand = compositor:
    if compositor == "labwc"
    then "${config.programs.labwc.package}/bin/labwc"
    else "${config.programs.niri.package}/bin/niri-session";

  compositorLabel = compositor:
    if compositor == "labwc"
    then "Labwc"
    else "Niri";

  sessionName = compositor:
    if builtins.length sessionCompositors == 1
    then "Noctalia"
    else "Noctalia (${compositorLabel compositor})";

  defaultCompositor =
    if builtins.elem cfg.compositor sessionCompositors
    then cfg.compositor
    else builtins.head sessionCompositors;

  compositorBranches = lib.concatStringsSep "\n" (map (compositor: ''
      ${lib.escapeShellArg compositor})
        exec ${compositorCommand compositor}
        ;;
    '')
    sessionCompositors);

  dispatcher = pkgs.writeShellScriptBin "noctalia-user-session" ''
    set -eu
    case "''${1:-}" in
    ${compositorBranches}
    esac
    exec ${compositorCommand cfg.compositor}
  '';

  sessionPackages = map (compositor:
    (pkgs.writeTextFile {
      name = "noctalia-${compositor}";
      destination = "/share/wayland-sessions/noctalia-${compositor}.desktop";
      text = ''
        [Desktop Entry]
        Name=${sessionName compositor}
        Comment=Noctalia desktop with ${compositorLabel compositor}
        Exec=${dispatcher}/bin/noctalia-user-session ${compositor}
        Type=Application
        DesktopNames=Noctalia
      '';
    })
    // {
      providedSessions = ["noctalia-${compositor}"];
    })
  sessionCompositors;
in {
  options.modules.desktop.noctalia = {
    enable = lib.mkEnableOption "Noctalia desktop shell and compositor";
    compositor = lib.mkOption {
      type = lib.types.enum ["niri" "labwc"];
      default = "niri";
      description = "Default compositor used when no greeter compositor choice is selected.";
    };

    greeter = {
      enable = lib.mkEnableOption "Noctalia Greeter as the graphical login screen";
      compositors = lib.mkOption {
        type = lib.types.listOf (lib.types.enum ["niri" "labwc"]);
        default = [];
        description = "Compositor sessions exposed at login. Empty means only the default compositor.";
      };
      settings = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Extra greeter.toml settings merged over the module defaults.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = niriEnabled;
    programs.labwc.enable = labwcEnabled;

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      recommendedServices.enable = lib.mkDefault true;
    };

    services.gvfs.enable = lib.mkDefault true;
    services.udisks2.enable = lib.mkDefault true;
    services.udisks2.mountOnMedia = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;

    environment.persistence."/persist".directories = lib.mkIf greeter.enable [
      "/var/lib/noctalia-greeter"
      "/var/lib/AccountsService"
    ];

    services.displayManager.noctalia-greeter = lib.mkIf greeter.enable {
      enable = true;
      settings =
        lib.recursiveUpdate {
          session.default = sessionName defaultCompositor;
          keyboard = {
            layout = "it";
            numlock = true;
          };
          idle.timeout = 300;
        }
        greeter.settings;
    };

    # Hide the compositors' raw sessions from the greeter; the Noctalia
    # dispatcher sessions above start the same compositors with Noctalia.
    services.displayManager.sessionPackages = lib.mkIf greeter.enable (lib.mkForce sessionPackages);
    services.displayManager.defaultSession = lib.mkIf greeter.enable (lib.mkForce "noctalia-${defaultCompositor}");
    environment.systemPackages = lib.mkIf greeter.enable [dispatcher];
  };
}
