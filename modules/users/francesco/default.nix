{ config, lib, inputs, ... }:

let
  cfg = config.modules.users.francesco;
in
{
  options.modules.users.francesco = {
    enable = lib.mkEnableOption "Francesco's user account";

    profiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''Home configuration profiles to enable for Francesco'';
      example = [ "base" "desktop" "development" "gaming" ];
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.francesco = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      hashedPassword = "$6$35m44XndUk77Ef6Z$enc0ff47i3K1JQxVAJDwzm.mptOyIufdCmWEUrhqRTPpyZ/14SX5CHVQMKaNVRSLpFuCC/SOT03suW1hkuLl91";
    };

    home-manager.users.francesco = { pkgs, ... }: {
      imports = [ inputs.noctalia.homeModules.default ];

      # Enable home modules based on profiles
      modules.home.base.enable = lib.elem "base" cfg.profiles || lib.elem "desktop" cfg.profiles || lib.elem "laptop" cfg.profiles || lib.elem "development" cfg.profiles || lib.elem "gaming" cfg.profiles;
      modules.home.desktop.enable = lib.elem "desktop" cfg.profiles || lib.elem "laptop" cfg.profiles;
      modules.home.laptop.enable = lib.elem "laptop" cfg.profiles;
      modules.home.development = lib.mkIf (lib.elem "development" cfg.profiles) {
        enable = true;
        git = {
          enable = true;
          userName = "Francesco Venturoli";
          userEmail = "f.venturoli@gmail.com";
        };
        github.enable = true;
      };
      modules.home.gaming.enable = lib.elem "gaming" cfg.profiles;

      home.persistence."/persist" = {
        directories = [
          "Dev"
          "Documents"
          "Downloads"
          "Pictures"
          ".ssh"
          ".local/share"
          ".config/Code"
          ".config/git"
        ];
        files = [
          ".bash_history"
        ];
      };

      home.stateVersion = "25.11";
    };
  };
}
