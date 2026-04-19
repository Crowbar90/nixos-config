{ pkgs, config, ... }:

{
  # Users configuration
  users.mutableUsers = false;

  users.users.root.hashedPasswordFile = config.sops.secrets."user-password/root".path;

  users.users.francesco = {
    uid = 1000;
    hashedPasswordFile = config.sops.secrets."user-password/francesco".path;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };

  # Shells
  programs.zsh.enable = true;

  # HM migration settings
  home-manager.backupFileExtension = "hm-backup";
}
