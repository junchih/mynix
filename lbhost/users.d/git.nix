{ config
, pkgs
, lib
, ...
}:

let

  inherit (builtins)
    trace
    concatLists
    any
    ;
  inherit (lib)
    filterAttrs
    mapAttrsToList
    ;
  inherit (config.lib.mylib)
    binding
    ;

  ssh-keys = binding
    concatLists
    (mapAttrsToList
      (user-name: user-conf:
        trace "allow ${user-name} to git"
          (user-conf.openssh.authorizedKeys.keys or [ ])))
    (filterAttrs
      (user-name: user-conf:
        !(user-conf.isSystemUser or false) &&
        user-name != "git" &&
        (any (grp: grp == "git") user-conf.extraGroups)))
    (config.users.users or { });

in
{
  description = "System user for git";
  isSystemUser = true;
  group = "git";
  createHome = true;
  home = "/home/git";
  shell = "${pkgs.git}/bin/git-shell";

  hashedPassword = "!";
  openssh.authorizedKeys.keys = ssh-keys;
}
