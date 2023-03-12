{ config
, pkgs
, lib
, ...
}:

{
  description = "Thomas Cat";
  isNormalUser = true;
  createHome = true;
  useDefaultShell = true;
  extraGroups = [ "git" ];
  packages = with pkgs; [ ];

  hashedPassword = config.users.users.jack.hashedPassword;
  openssh.authorizedKeys.keys = [ ];
}
