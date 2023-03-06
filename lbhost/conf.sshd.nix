{ ... }:

with builtins;
{
  services.openssh = {

    enable = trace "Enable OpenSSH" true;
    useDns = false;
    banner = null;

    permitRootLogin = "no";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;

    extraConfig = ''
      Protocol 2
      Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
      LoginGraceTime 30
      MaxAuthTries 2
      MaxSessions 5
      MaxStartups 5:30:30
    '';

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
