{ pkgs
, ...
}:

{
  description = "blabla";
  isNormalUser = true;
  createHome = true;
  useDefaultShell = true;
  extraGroups = [ ];
  packages = with pkgs; [
    git
  ];

  # hashedPassword is the result of `mkpasswd 'I am security!'`
  hashedPassword = "$y$j9T$YiEyoZysjoNDw0G38EdAW/$feB1MzKH7EjdH.K/63.8jAHNVgOJ1Dt/LcQlvyNwq05";
  openssh.authorizedKeys.keys = [ ];
}
