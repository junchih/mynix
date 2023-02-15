{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, ...
}@pkg-args:

let

  mylib = import ../lib { inherit lib; };

  inherit (mylib)
    Y
    readNixTree
    treeApplyArgs
    ;

  mypkgs-generator =
    mypkgs:
    treeApplyArgs
      (readNixTree (file: file == "default.nix") ./.)
      (pkg-args // { inherit mypkgs mylib; });

in
Y mypkgs-generator
