{ ... }:

with builtins;
{
  services.openssh = {
    enable = trace "Enable OpenSSH" true;
    useDns = false;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };
}
