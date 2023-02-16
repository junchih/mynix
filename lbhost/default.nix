__seed:
{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, ...
}@_module-args:

let

  mypkgs = import ../. module-args;
  mylib = mypkgs.lib;
  module-args = _module-args // { inherit mypkgs mylib; };

  inherit (builtins)
    trace
    readDir
    attrNames
    foldl'
    isFunction
    ;
  inherit (lib)
    filterAttrs
    hasPrefix
    hasSuffix
    recursiveUpdate
    ;
  inherit (mylib)
    Y
    ;

  seed-section = module-args:
    recursiveUpdate
      { networking.hostName = "nixos"; }
      (if isFunction __seed then __seed module-args else __seed);
  host-name =
    let
      seed-conf = seed-section module-args;
      name = seed-conf.networking.hostName;
    in
    trace "Host Name: ${name}" name;
  host-section = import (./. + "/host.${host-name}.nix");

  list-sections = path:
    let
      dir-content = filterAttrs
        (
          file-name: file-type:
            file-type == "regular" &&
            hasPrefix "conf." file-name &&
            hasSuffix ".nix" file-name
        )
        (readDir path);
      sections = map
        (file-name:
          import (path + ("/" + file-name)))
        (attrNames dir-content);
    in
    sections;

  sections = [ host-section ] ++ (list-sections ./.) ++ [ seed-section ];

  configuration-wrapper = configuration:
    let
      configs = map
        (section: section (module-args // { inherit configuration; }))
        sections;
      imports = foldl' (a: b: a ++ b) [ ]
        (map (conf: conf.imports or [ ]) configs);
    in
    (foldl' recursiveUpdate { } configs) // { inherit imports; };

in
Y configuration-wrapper
