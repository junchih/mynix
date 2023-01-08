{ pkgs ? import <nixpkgs> {}
, mylib
, ...
}@pkg-args:

let

  inherit (builtins)
    attrNames
    readDir
    listToAttrs
    filter
  ;

  pkg-files =
    filter
    (file-name: file-name != "default.nix")
    (attrNames (readDir ./.));

  pkg-pairs =
    map
    (
      file-name:
      { name = file-name; value = import (./. + "/${file-name}") pkg-args; }
    )
    pkg-files;

  pkgs = listToAttrs pkg-pairs;

in pkgs
