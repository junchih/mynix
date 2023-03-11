{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, config ? { }
, ...
}@module-args:

let

  mypkgs = import ../. module-args;
  mylib = mypkgs.lib;

  inherit (builtins)
    trace
    readDir
    ;
  inherit (lib)
    filterAttrs
    hasPrefix
    hasSuffix
    mapAttrsToList
    ;
  inherit (mylib)
    binding
    ;

  hostname =
    let hostname = config.networking.hostName;
    in trace "HostName: ${hostname}" hostname;

  imports = binding
    (mapAttrsToList
      (file-name: _:
        ./. + ("/" + file-name)))
    (filterAttrs
      (file-name: file-type:
        file-type == "regular" &&
        hasPrefix "conf." file-name &&
        hasSuffix ".nix" file-name))
    readDir
    ./.;

in
{
  inherit imports;
  lib = { inherit mypkgs mylib; };
}
