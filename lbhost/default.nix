_instance:
{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, config
, ...
}@module-args:

let

  inherit (builtins)
    readDir
    attrNames
    foldl'
    ;
  inherit (lib)
    filterAttrs
    hasPrefix
    hasSuffix
    recursiveUpdate
    ;

  instance = recursiveUpdate { networking.hostName = "nixos"; } _instance;
  host-base = import (./. + "/host.${instance.networking.hostName}.nix") module-args;

  list-partitions =
    path:
    let
      dir-content =
        filterAttrs
          (
            file-name: file-type:
              file-type == "regular" &&
              hasPrefix "conf." file-name &&
              hasSuffix ".nix" file-name
          )
          (readDir path);
      list =
        map
          (file-name: path + ("/" + file-name))
          (attrNames dir-content);
    in
    list;

  imports = foldl' (a: b: a ++ b) [ ]
    (
      [
        (instance.imports or [ ])
        (host-base.imports or [ ])
      ] ++ (
        map
          (file: (import file module-args).imports or [ ])
          (list-partitions ./.)
      )
    );

  configs = foldl' recursiveUpdate { }
    (
      [
        host-base
      ] ++ (
        map
          (file: import file module-args)
          (list-partitions ./.)
      ) ++ [
        instance
      ]
    );

in
configs // { imports = imports; }
