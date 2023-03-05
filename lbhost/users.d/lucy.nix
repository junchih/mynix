{ pkgs
, ...
}:

{
  description = "Lucy Chen";
  isNormalUser = true;
  createHome = true;
  useDefaultShell = true;
  extraGroups = [ ];
  packages = with pkgs; [ ];

  hashedPassword = "!";
  openssh.authorizedKeys.keys = [ ];
}
