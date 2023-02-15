{ lib
, ...
}:

let

  mylib-generator =
    mylib:
    let
      lib-args = { inherit lib mylib; };
      utils = import ./utils.nix lib-args;
    in
    {
      inherit (utils)
        Y
        readNixTree
        treeApplyArgs
        ;
    };

  _Y = X: X (_Y X);

in
_Y mylib-generator
