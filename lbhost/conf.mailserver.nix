{ config
, pkgs
, lib
, ...
}:

let

  inherit (builtins)
    trace
    elemAt
    fetchTarball
    ;
  inherit (lib)
    optionalAttrs
    splitVersion
    version
    mapAttrs'
    nameValuePair
    filterAttrs
    ;
  inherit (config.lib.mylib)
    binding
    ;

  hostname = config.networking.hostName;
  maybe = optionalAttrs (
    hostname == "dot-vc2"
  );

  mx-webroot = pkgs.writeTextDir "index.html" ''
    <!DOCTYPE html>
    <html>
    <head><title>Hello</title></head>
    <body>Hello World!</body>
    </html>
  '';

  email-accounts = binding
    (mapAttrs'
      (key: conf:
        let
          email = "${conf.name or key}@func.xyz";
          hashedPassword = conf.hashedPassword or "!";
          quota = "512M";
        in
        nameValuePair
          (trace "serving email ${email}" email)
          { inherit hashedPassword quota; }
      ))
    (filterAttrs
      (name: conf:
        name != "root" &&
        (conf.name or "") != "root" &&
        (conf.isNormalUser or (! (conf.isSystemUser or false)))
      ))
    (
      (config.users.users or { }) //
      (config.users.extraUsers or { })
    );
in
{

  imports = [
    (fetchTarball
      {
        url =
          let
            vers = splitVersion version;
            tag = "nixos-${elemAt vers 0}.${elemAt vers 1}";
          in
          "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/" +
          "-/archive/${tag}/nixos-mailserver-${tag}.tar.gz";
        sha256 = "1h1r4x2ffqwyk0ql6kjvcpg1bdiimyzhrsvn49702fsgzpx57fhd";
      })
  ];

  security.acme = maybe {
    acceptTerms = true;
    defaults.email = "gerald.mouse@func.xyz";
  };

  services.nginx = maybe {
    virtualHosts."${config.mailserver.fqdn}" = {
      root = "${mx-webroot}";
    };
  };

  mailserver = maybe {

    enable = trace "Enable mailserver of SNM" true;
    fqdn = "mx.func.xyz";
    sendingFqdn = "mx.func.xyz";
    domains = [ "func.xyz" ];
    dkimSigning = true;
    dkimSelector = "mx";

    loginAccounts = email-accounts;

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;
    # Enable flags of IMAP, POP3 and SMTP
    enableImap = false;
    enableImapSsl = false;
    enablePop3 = true;
    enablePop3Ssl = true;
    enableSubmission = true;
    enableSubmissionSsl = true;

    # Enable the ManageSieve protocol
    enableManageSieve = false;
    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;
  };
}
