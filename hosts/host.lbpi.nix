{ config, pkgs, lib, ... }:

{
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # !!! If your board is a Raspberry Pi 1, select this:
  boot.kernelPackages = pkgs.linuxPackages_rpi;
  # On other boards, pick a different kernel, note that on most boards with good mainline support, default, latest and hardened should all work
  # Others might need a BSP kernel, which should be noted in their respective wiki entries

  # !!! This is only for ARMv6 / ARMv7. Don't enable this on AArch64, cache.nixos.org works there.
  nix.settings.substituters = lib.mkForce [ "https://cache.armv7l.xyz" ];
  nix.settings.trusted-public-keys = [ "cache.armv7l.xyz-1:kBY/eGnBAYiqYfg0fy0inWhshUo+pGFM3Pj7kIkmlBk=" ];
}
