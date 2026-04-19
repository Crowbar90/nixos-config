{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nemo
    nixfmt
    qt6.qtwayland
    yazi
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "nemo.desktop" ];
    };
    associations.added = {
      "inode/directory" = [ "nemo.desktop" ];
    };
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        savePath = "/home/francesco/Pictures/Screenshots";
        disabledTrayIcon = false;
        showStartupLaunchMessage = false;
        saveAsFileExtension = ".png";
        showDesktopNotification = true;
        showAbortNotification = false;
        showHelp = true;
        showSidePanelButton = true;

        useGrimAdapter = true;
        disabledGrimWarning = false;
      };
    };
  };
}
