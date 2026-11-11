{lib, ...}: let
  outputType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Output connector name, e.g. DP-2 or HDMI-A-1.";
      };

      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether this output is enabled.";
      };

      primary = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Mark this output as the XRandR primary monitor. XWayland clients
          (including Steam/Proton games) use it as monitor 0; Wayland clients
          ignore it.
        '';
      };

      mode = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "1920x1200";
        description = "Output mode as <width>x<height>[@<rate>].";
      };

      position = lib.mkOption {
        type = lib.types.nullOr (lib.types.submodule {
          options = {
            x = lib.mkOption {
              type = lib.types.int;
              default = 0;
            };
            y = lib.mkOption {
              type = lib.types.int;
              default = 0;
            };
          };
        });
        default = null;
        example = {
          x = 1920;
          y = 0;
        };
        description = "Position in the global coordinate space.";
      };

      scale = lib.mkOption {
        type = lib.types.nullOr lib.types.float;
        default = null;
        description = "Output scale factor.";
      };

      transform = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [
          "normal"
          "90"
          "180"
          "270"
          "flipped"
          "flipped-90"
          "flipped-180"
          "flipped-270"
        ]);
        default = null;
        description = "Output rotation/transform.";
      };
    };
  };
in {
  imports = [
    ./apps
    ./compositors
    ./shells/noctalia
  ];

  options.modules.home.desktop = {
    keyboard.layout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "XKB layout used by the compositors.";
    };

    outputs = lib.mkOption {
      type = lib.types.listOf outputType;
      default = [];
      description = "Output layout applied by each enabled compositor.";
    };
  };
}
