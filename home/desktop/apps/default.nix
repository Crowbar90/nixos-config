{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.desktop.apps;
in {
  options.modules.home.desktop.apps = {
    enable = lib.mkEnableOption "the desktop application defaults";

    terminal = lib.mkOption {
      type = lib.types.enum ["kitty"];
      default = "kitty";
    };

    launcher = lib.mkOption {
      type = lib.types.enum ["fuzzel"];
      default = "fuzzel";
    };

    screenLocker = lib.mkOption {
      type = lib.types.enum ["swaylock"];
      default = "swaylock";
    };

    notificationDaemon = lib.mkOption {
      type = lib.types.enum ["mako"];
      default = "mako";
    };

    idleDaemon = lib.mkOption {
      type = lib.types.enum ["swayidle"];
      default = "swayidle";
    };

    wallpaper = lib.mkOption {
      type = lib.types.enum ["swaybg"];
      default = "swaybg";
    };

    fileManager = lib.mkOption {
      type = lib.types.enum ["nemo"];
      default = "nemo";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg = lib.mkIf (cfg.fileManager == "nemo") {
      desktopEntries.nemo = {
        name = "Nemo";
        exec = "${pkgs.nemo-with-extensions}/bin/nemo";
      };

      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = ["nemo.desktop"];
          "application/x-gnome-saved-search" = ["nemo.desktop"];
        };
      };
    };

    dconf.settings."org/cinnamon/desktop/applications/terminal".exec =
      lib.mkIf (cfg.terminal == "kitty")
      "kitty";

    programs.kitty.enable = lib.mkIf (cfg.terminal == "kitty") true;
    programs.fuzzel.enable = lib.mkIf (cfg.launcher == "fuzzel") true;
    programs.swaylock.enable = lib.mkIf (cfg.screenLocker == "swaylock") true;

    services.mako.enable = lib.mkIf (cfg.notificationDaemon == "mako") true;
    services.swayidle.enable = lib.mkIf (cfg.idleDaemon == "swayidle") true;
    services.polkit-gnome.enable = true;

    home.packages =
      lib.optionals (cfg.fileManager == "nemo") [pkgs.nemo-with-extensions]
      ++ lib.optionals (cfg.wallpaper == "swaybg") [pkgs.swaybg];
  };
}
