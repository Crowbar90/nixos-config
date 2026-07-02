{ pkgs, ... }:

{
  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Internationalization
  time.timeZone = "Europe/Rome";
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

}
