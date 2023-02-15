{ ... }:

with builtins;
{
  services.openssh.enable = trace "Enable OpenSSH" true;
  services.openssh.useDns = false;
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;
}
