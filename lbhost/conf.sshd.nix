{ ... }:

with builtins;
{
  services.openssh = {

    enable = trace "Enable OpenSSH" true;
    useDns = false;
    banner = null;
    forwardX11 = false;

    permitRootLogin = "no";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes128-gcm@openssh.com"
      "aes256-ctr"
      "aes192-ctr"
      "aes128-ctr"
    ];
    macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
      "hmac-sha2-512"
      "hmac-sha2-256"
      "umac-128@openssh.com"
    ];

    extraConfig = ''
      Protocol 2
      PermitUserEnvironment no
      IgnoreRhosts yes
      HostbasedAuthentication no
      LoginGraceTime 30
      MaxAuthTries 2
      MaxSessions 5
      MaxStartups 5:20:25
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
