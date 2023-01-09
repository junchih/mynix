{ pkgs ? import <nixpkgs> {}
, lib ? import <nixpkgs/lib>
, mylib
, ...
}@pkg-args:

let

  inherit (builtins)
    attrNames
    readDir
    listToAttrs
    filter
    map
  ;
  inherit (lib)
    removeSuffix
  ;

  pkg-files =
    filter
    (file-name: file-name != "default.nix")
    (attrNames (readDir ./.));

  pkg-pairs =
    map
    ( file-name:
      {
        name = removeSuffix ".nix" file-name;
        value = import (./. + "/${file-name}") pkg-args;
      }
    )
    pkg-files;

  pkgs = listToAttrs pkg-pairs;

in pkgs
