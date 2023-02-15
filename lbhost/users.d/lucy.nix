{ pkgs, ... }:

{
  description = "Lucy Chen";
  isNormalUser = true;
  createHome = true;
  useDefaultShell = true;
  extraGroups = [ ];
  packages = with pkgs; [ ];

  hashedPassword = "$6$Nmptrcb5twJyF29Y$cFieAWp7PqsO2.rjxw3xWwkGjx5E5UOHso2TShMvS1HCz/1dp/tHJcQNNDD5pTUWgrkVWFsvKIr8QaoSrLMGm1";

  openssh.authorizedKeys.keys = [ ];
}
