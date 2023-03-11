{ config
, pkgs
, lib
, ...
}@module-args:

let

  inherit (builtins)
    trace
    readDir
    ;
  inherit (lib)
    hasSuffix
    removeSuffix
    mapAttrs'
    filterAttrs
    nameValuePair
    ;
  inherit (config.lib.mylib)
    binding
    ;

  user-configs = binding
    (mapAttrs'
      (file-name: _:
        let user = removeSuffix ".nix" file-name;
        in nameValuePair
          (trace "register user: ${user}" user)
          (import (./users.d + ("/" + file-name)) module-args)))
    (filterAttrs
      (file-name: file-type:
        file-type == "regular" && hasSuffix ".nix" file-name))
    readDir ./users.d;

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

  users.users = user-configs;
}
