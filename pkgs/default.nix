{ pkgs ? import <nixpkgs> { }
, mylib ? import ../lib { }
, ...
}@pkg-args:

let

  inherit (mylib)
    Y
    readNixTree
    treeApplyArgs
    ;

  build-mypkgs = mypkgs:
    treeApplyArgs
      (readNixTree (file: file == "default.nix") ./.)
      (pkg-args // {
        inherit mypkgs;
      });

in
Y build-mypkgs
