{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
# kvm for virtualisation?
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

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

   fileSystems."/drives/library+vms" =
    { device = "/dev/disk/by-label/library+vms";
      fsType = "btrfs";
      options = [ "compress=zstd" "nofail" ];
    };

  # points to luks partition, which contains btrfs system
  boot.initrd.luks.devices."luks-e3b3a2b7-e18d-4fda-8f2f-4fbf0c36fd3f".device = "/dev/disk/by-uuid/e3b3a2b7-e18d-4fda-8f2f-4fbf0c36fd3f";

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
