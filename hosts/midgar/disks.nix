{
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["size=2G" "mode=755"];
    };

    nodev."/boot" = {
      fsType = "vfat";
      device = "/dev/disk/by-uuid/469D-251E";
    };

    nodev."/mnt/warm" = {
      device = "/dev/disk/by-label/Warm";
      fsType = "ntfs3";
      mountOptions = [
        "rw"
        "uid=1000"
        "gid=100"
        "umask=000"
        "fmask=000"
        "dmask=000"
        "iocharset=utf8"
        "nofail"
        "x-systemd.device-timeout=10s"
        "force"
      ];
    };

    nodev."/mnt/cold" = {
      device = "/dev/disk/by-label/Cold";
      fsType = "ntfs3";
      mountOptions = [
        "rw"
        "uid=1000"
        "gid=100"
        "umask=000"
        "fmask=000"
        "dmask=000"
        "iocharset=utf8"
        "nofail"
        "x-systemd.device-timeout=10s"
      ];
    };

    disk = {
      main = {
        device = "/dev/disk/by-id/ata-Fanxiang_S101Q_512GB_AA00000000020123";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            swap = {
              size = "16G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
            nixos = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/var/log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
