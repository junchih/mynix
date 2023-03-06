let
  mynix =


    builtins.fetchTarball (
      "https://github.com/junchih/mynix/archive/" +
      "master" +
      ".tar.gz"
    );


in
import (mynix + "/lbhost")
  ({ config, pkgs, lib, ... }: {
    networking.hostName = "lbmsi";
    imports = [
      ./hardware-configuration.nix
      ./vault.nix
    ];
  })
