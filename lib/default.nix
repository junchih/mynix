{ lib
, ...
}:

let

  mylib-wrapper =
    mylib:
    let
      importing-args = { inherit lib mylib; };
    in
    {
      inherit (import ./funny.nix importing-args)
        Y S K I B C W;
      inherit (import ./functional.nix importing-args)
        binding
        foldr'
        rapply
        lapply
        ;
      inherit (import ./utils.nix importing-args)
        readNixTree
        treeApplyArgs
        ;
    };

  _Y = X: X (_Y X);

in
_Y mylib-wrapper
