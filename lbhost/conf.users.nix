{ pkgs
, lib
, ...
}@module-args:

let

  inherit (builtins)
    trace
    attrNames
    readDir
    filter
    ;
  inherit (lib)
    hasSuffix
    removeSuffix
    genAttrs
    mapAttrs
    ;

  import-file = file: import file module-args;

  list-user-files =
    path:
    let
      file-names = filter
        (file-name: hasSuffix ".nix" file-name)
        (attrNames (readDir path));
      user-names = map (removeSuffix ".nix") file-names;
    in
    genAttrs user-names (name: path + "/${name}.nix");

  read-user-confs = mapAttrs
    (user: conf-file:
      trace "register user: ${user}" (import-file conf-file)
    );

in
{
  # Set immutable user configurations
  users.mutableUsers = false;
  # Set zsh as the user default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  # Set global environment variables
  environment.variables.CLICOLOR = "1";
  environment.variables.LSCOLORS = "gxBxhxDxfxhxhxhxhxcxcx";
  # set ~/bin into $PATH
  environment.homeBinInPath = true;

  users.users = read-user-confs (list-user-files (./users.d));
}
