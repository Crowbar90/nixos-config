{ ... }:

{
  home.sessionVariables = {
    # Force Qt applications to use Wayland
    QT_QPA_PLATFORM = "wayland";
    # Fix for Java apps
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # Ensure apps know where the Wayland socket is
    XDG_SESSION_TYPE = "wayland";
  };
}
