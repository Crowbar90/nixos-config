{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.modules.home.development;
in
{
  options.modules.home.development = {
    enable = lib.mkEnableOption "Development tools and environment";

    git = {
      enable = lib.mkEnableOption "Git configuration" // { default = cfg.enable; };
      userName = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Git user.name";
      };
      userEmail = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Git user.email";
      };
    };

    github = {
      enable = lib.mkEnableOption "GitHub CLI" // { default = cfg.enable; };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = lib.mkIf cfg.git.enable {
      enable = true;
      settings = {
        user = {
          name = cfg.git.userName;
          email = cfg.git.userEmail;
        };
      };
    };

    programs.gh = lib.mkIf cfg.github.enable {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    home.packages = [
      pkgs.dotnet-sdk_10
    ];
  };
}
