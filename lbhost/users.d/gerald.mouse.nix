{ config
, pkgs
, lib
, ...
}:

{
  description = "Gerald Mouse";
  isNormalUser = true;
  createHome = true;
  useDefaultShell = true;
  extraGroups = [ ];
  packages = with pkgs; [ ];

  hashedPassword = config.users.users.jack.hashedPassword;
  openssh.authorizedKeys.keys = [ ];
}
