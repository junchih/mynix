{ ... }:

with builtins;
{
  services.openssh = {
    enable = trace "Enable OpenSSH" true;
    useDns = false;
    permitRootLogin = "no";
    passwordAuthentication = false;
    ports = [
      22
      44307
      44321
      44335
      44349
      44363
      44377
    ];
  };
}
