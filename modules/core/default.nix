{ pkgs, ... }:

{
  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Internationalization
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # NetworkManager
  networking.networkmanager.enable = true;

  # Impermanence
  programs.fuse.userAllowOther = true;

  # Tools
  environment.systemPackages = with pkgs; [
    curl    
    git
    vim
    wget
  ];

  # User
  users.users.francesco = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = "$6$35m44XndUk77Ef6Z$enc0ff47i3K1JQxVAJDwzm.mptOyIufdCmWEUrhqRTPpyZ/14SX5CHVQMKaNVRSLpFuCC/SOT03suW1hkuLl91";    
  };
}
