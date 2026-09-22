{ config, pkgs, inputs, ... }:

let
  persistentDir = "/this";
in
{
  # base ephemeral fs setup:
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
      neededForBoot = true;
    };

  };

  # swap:
  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  # persistence:
  fileSystems.${persistentDir} = {
    device = "/dev/disk/by-label/this";
    fsType = "ext4";
    neededForBoot = true;
  };
  environment.persistence.${persistentDir} = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      { directory = "/trash"; mode = "0777"; }
    ];
    files = [
      "/etc/machine-id"
    ];
    users.six = {
      directories = [
        "work"
        "downloads"
        "data"
        ".config"
        { directory = ".ssh"; mode = "0700"; }
      ];
    };
  };

  # symlinks:
  system.activationScripts.symlinks = {
    deps =  [
      "specialfs"
    ];
    text = ''
      ln -sfn /home/six/.config /home/six/config
    '';
  };
}