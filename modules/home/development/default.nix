{ config, lib, ... }:

let
  cfg = config.modules.development;
in
{
  options.modules.development = {
    enable = lib.mkEnableOption "development tools";

    git = {
      enable = lib.mkEnableOption "Git";
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
      enable = lib.mkEnableOption "GitHub CLI";
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
  };
}
