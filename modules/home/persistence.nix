{ config, lib, ... }:

let
  cfg = config.modules.persistence;
in
{
  options.modules.persistence = {
    enable = lib.mkEnableOption "impermanence user persistence";
    path = lib.mkOption {
      type = lib.types.str;
      default = "/persist";
      description = "Base directory for user persistence";
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence."${cfg.path}" = {
      directories = [
        "Dev"
        "Documents"
        "Downloads"
        "Pictures"
        ".ssh"
        ".local/share"
        ".config/VSCodium"
        ".config/opencode"
        ".config/git"
        ".vscode-oss"
      ];
      files = [
        ".bash_history"
      ];
    };
  };
}
