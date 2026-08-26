{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.home.coding;
  antigravity = inputs.antigravity-nix.packages.x86_64-linux;
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

    docker = {
      enable = lib.mkEnableOption "Docker CLI";
    };

    dotnet = {
      enable = lib.mkEnableOption ".NET SDK";
    };

    antigravity = {
      enable = lib.mkEnableOption "Google Antigravity base app";
      ide = {
        enable = lib.mkEnableOption "Google Antigravity IDE";
      };
      cli = {
        enable = lib.mkEnableOption "Google Antigravity CLI (agy)";
      };
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
      (lib.optionals cfg.docker.enable [docker])
      ++ (lib.optionals cfg.dotnet.enable [dotnet-sdk_10])
      ++ (lib.optionals cfg.antigravity.enable [antigravity.default])
      ++ (lib.optionals cfg.antigravity.ide.enable [antigravity.google-antigravity-ide])
      ++ (lib.optionals cfg.antigravity.cli.enable [antigravity.google-antigravity-cli])
      ++ (lib.optionals cfg.vscodium.enable [vscodium])
      ++ (lib.optionals cfg.opencode.enable [opencode])
      ++ (lib.optionals cfg.opencode.desktop.enable [opencode-desktop]);
  };
}
