{ config
, pkgs
, lib
, ...
}:

let

  inherit (builtins)
    trace
    concatLists
    ;
  inherit (lib)
    filterAttrs
    mapAttrsToList
    ;

  attr-users = filterAttrs
    (name: attr:
      name != "git" &&
      !(attr.isSystemUser or false) &&
      (attr.openssh.authorizedKeys.keys or [ ]) != [ ]
    )
    (
      (config.users.users or { }) //
      (config.users.extraUsers or { })
    );
  user-ssh-keys = mapAttrsToList
    (user: attr:
      trace "allow ${user} to git" (attr.openssh.authorizedKeys.keys or [ ])
    )
    attr-users;
  ssh-keys = concatLists user-ssh-keys;

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
