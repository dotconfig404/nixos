{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ./configuration.nix ];
    #[ (modulesPath + "/installer/scan/not-detected.nix") ./configuration.nix 
    #];

  networking.hostName = "noxy"; 
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
# kvm for virtualisation?
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # for the root partition: points to luks partition, which contains btrfs system
  # omnus/omnus-backup actually has no luks partition, instead it is just a full encrypted luks device, same procedure tho
  boot.initrd.luks.devices = {
    "luks-e3b3a2b7-e18d-4fda-8f2f-4fbf0c36fd3f" = {
      device = "/dev/disk/by-uuid/e3b3a2b7-e18d-4fda-8f2f-4fbf0c36fd3f";
    };
    "omnus" = {
      device = "/dev/disk/by-uuid/b4ed9add-3e10-4740-8b81-5bd9c5325e3a";
    };
    "omnus-backup" = {
      device = "/dev/disk/by-uuid/a55e559e-394e-4687-a4a7-1c7b60e0ceb5";
    };
  };

    fileSystems."/" =
    # points to btrfs system, with option to point to the nixos subvolume
    { device = "/dev/disk/by-label/btrfs";
      fsType = "btrfs";
      options = [ "subvol=nixos" "compress=zstd" ];
    };

   fileSystems."/drives/omnus" =
    { device = "/dev/disk/by-label/omnus";
      fsType = "btrfs";
      options = [ "compress=zstd" "nofail" ];
    };

   fileSystems."/drives/omnus-backup" =
    { device = "/dev/disk/by-label/omnus-backup";
      fsType = "btrfs";
      options = [ "compress=zstd" "nofail" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
