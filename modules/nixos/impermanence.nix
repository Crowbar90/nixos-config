{ ... }:

{
  # Impermanence Logic
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/networkmanager"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
