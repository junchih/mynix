{ config, pkgs, lib, ... }:

{
  imports = lib.optionals (builtins.pathExists ./default.nix) [ ./default.nix ];
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # !!! If your board is a Raspberry Pi 1, select this:
  boot.kernelPackages = pkgs.linuxPackages_rpi;
  # On other boards, pick a different kernel, note that on most boards with good mainline support, default, latest and hardened should all work
  # Others might need a BSP kernel, which should be noted in their respective wiki entries
}
