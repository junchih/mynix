# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "lbvan"; # Define your hostname.

  # network configuration
  networking.interfaces.ens3.useDHCP = true;
  # ipv6 pool
  networking.interfaces.ens3.ipv6.addresses =
    let
      net = "2401:c080:1400:484d:77a1:";
      netlen = 64;
      hosts = [
        # original
        "13ba:1211:35e5"
        "6520:d7b5:d0f6"
        "19cd:2f6f:ba05"
        "251c:7afd:a4f8"
        "92d8:401c:3823"
        "d28b:fc08:3e0b"
        "f4a7:77df:f9f8"
        "fab7:c7ae:6522"
        "4f0b:c387:3462"
        "513b:2bc6:87a6"
        "3179:892a:5d77"
        "34a2:f6f0:70b8"
        # additional
        "35e5:1211:13ba"
        "d0f6:d7b5:6520"
        "ba05:2f6f:19cd"
        "a4f8:7afd:251c"
        "3823:401c:92d8"
        "3e0b:fc08:d28b"
        "f9f8:77df:f4a7"
        "6522:c7ae:fab7"
        "3462:c387:4f0b"
        "87a6:2bc6:513b"
        "5d77:892a:3179"
        "70b8:f6f0:34a2"
      ];
    in
    map
      (host:
        {
          address = net + host;
          prefixLength = netlen;
        })
      hosts;
}
