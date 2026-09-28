{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.home.coding;
in {
  options.modules.home.coding = {
    enable = lib.mkEnableOption "software development (coding) tools";

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

    dotnet = {
      enable = lib.mkEnableOption ".NET SDK";
    };

    vscodium = {
      enable = lib.mkEnableOption "VSCodium editor";
    };

    opencode = {
      enable = lib.mkEnableOption "OpenCode CLI agent";
      desktop = {
        enable = lib.mkEnableOption "OpenCode Desktop app";
      };
    };

    jetbrains = {
      toolbox = {
        enable = lib.mkEnableOption "JetBrains Toolbox";
      };

      rider = {
        enable = lib.mkEnableOption "JetBrains Rider";
      };
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
        push = {
          autoSetupRemote = true;
        };
      };
    };

    programs.gh = lib.mkIf cfg.github.enable {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    home.packages = with pkgs;
      (lib.optionals cfg.dotnet.enable [dotnet-sdk_10])
      ++ (lib.optionals cfg.vscodium.enable [vscodium])
      ++ (lib.optionals cfg.opencode.enable [opencode])
      ++ (lib.optionals cfg.opencode.desktop.enable [opencode-desktop])
      ++ (lib.optionals cfg.jetbrains.toolbox.enable [jetbrains-toolbox])
      ++ (lib.optionals cfg.jetbrains.rider.enable [jetbrains.rider]);
  };
}
