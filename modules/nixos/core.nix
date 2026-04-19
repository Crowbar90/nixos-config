{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Experimental features for Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader & Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Internationalization
  services.xserver.xkb.layout = "it";
  console.keyMap = "it";

  # Input
  services.libinput.enable = true;

  # Secrets management
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [
      "/home/francesco/.ssh/id_ed25519"
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    # Secrets provided by sops-nix
    secrets = {
      "user-password/francesco".neededForUsers = true;
      "user-password/root".neededForUsers = true;
      ssh-host-key = {
        path = "/etc/ssh/ssh_host_ed25519_key";
      };
    };
  };

  # SSH
  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  system.stateVersion = "25.11";
}
