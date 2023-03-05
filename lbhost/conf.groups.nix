{ configuration
, lib
, ...
}:

let
  inherit (builtins)
    trace
    concatLists
    ;
  inherit (lib)
    optionals
    genAttrs
    mapAttrsToList
    ;
  users = (configuration.users.users or { })
    // (configuration.users.extraUsers or { });
  user-groups = mapAttrsToList
    (user: attr:
      let
        primary-group = attr.group or "";
        extra-groups = attr.extraGroups or [ ];
      in
      optionals (primary-group != "") [ primary-group ] ++ extra-groups
    )
    users;
  groups = concatLists user-groups;
  attr-groups = genAttrs groups (group: trace "auto added group: ${group}" { });
in
{
  users.groups = attr-groups;
}
