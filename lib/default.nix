{ pkgs ? import <nixpkgs> { }
, ...
}@lib-args:

let

  utils = import ./utils.nix lib-args;

in
{
  inherit (utils)
    Y
    readNixTree
    treeApplyArgs
    ;
}
