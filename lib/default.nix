{ lib
, ...
}:

let

  mylib-wrapper =
    mylib:
    let
      lib-args = { inherit lib mylib; };
      funny = import ./funny.nix lib-args;
      utils = import ./utils.nix lib-args;
    in
    {
      inherit (funny)
        Y S K I B C W;
      inherit (utils)
        readNixTree
        treeApplyArgs
        ;
    };

  _Y = X: X (_Y X);

in
_Y mylib-wrapper
