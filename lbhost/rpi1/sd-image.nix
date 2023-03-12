{ lib, pkgs, ... }:

{
  # solving "Module ahci not found error",
  # from https://github.com/NixOS/nixpkgs/issues/126755
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  nixpkgs.crossSystem.system = "armv6l-linux";

  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix>
  ];


  system.stateVersion = "22.11";

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  environment.systemPackages = with pkgs; [
    git
  ];
  users.mutableUsers = false;
  users.users.pi = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
    password = "raspberry";
  };
}
