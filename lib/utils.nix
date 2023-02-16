{ mylib
, lib
, ...
}:

let

  inherit (builtins)
    readDir
    attrNames
    pathExists
    isAttrs
    isFunction
    listToAttrs
    ;
  inherit (lib)
    filterAttrs
    hasSuffix
    removeSuffix
    mapAttrs
    ;

in
rec {
  readNixTree = ignore-f: path:
    let

      matched = filterAttrs (n: _: !(ignore-f n)) (readDir path);
      dirs =
        attrNames (
          filterAttrs (_: type: type == "directory") matched
        );
      nix-files =
        attrNames (
          filterAttrs
            (name: type:
              (type == "regular") && (hasSuffix ".nix" name)
            )
            matched
        );

      file-pairs =
        map
          (file-name:
            {
              name = removeSuffix ".nix" file-name;
              value = import (path + "/${file-name}");
            }
          )
          nix-files;
      dir-pairs =
        map
          (dir-name:
            {
              name = dir-name;
              value =
                if pathExists (path + "/${dir-name}/default.nix") then
                  import (path + "/${dir-name}/default.nix")
                else
                  readNixTree ignore-f (path + "/${dir-name}");
            }
          )
          dirs;
      remove-dummy-attr = attrs:
        let
          recursively-cleaned = mapAttrs
            (k: v:
              if isAttrs v then
                remove-dummy-attr v
              else
                v
            )
            attrs;
        in
        filterAttrs
          (_: v:
            !(isAttrs v) || (v != { })
          )
          attrs;

    in
    (remove-dummy-attr (listToAttrs dir-pairs)) // (listToAttrs file-pairs);

  treeApplyArgs = attrs: args:
    mapAttrs
      (_: v:
        if isFunction v then
          v args
        else if isAttrs v then
          treeApplyArgs v args
        else
          v
      )
      attrs;
}
