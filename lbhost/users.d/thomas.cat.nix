{ configuration
, pkgs
, lib
, ...
}:

{
  description = "Thomas Cat";
  isNormalUser = true;
  createHome = true;
  useDefaultShell = true;
  extraGroups = [ ];
  packages = with pkgs; [ ];

  hashedPassword = configuration.users.users.jack.hashedPassword;
  openssh.authorizedKeys.keys = [ ];
}
