{ configuration
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
    optionals
    splitVersion
    version
    mapAttrs'
    nameValuePair
    filterAttrs
    ;

  mailserver-url =
    let
      vers = splitVersion version;
      tag = "nixos-${elemAt vers 0}.${elemAt vers 1}";
    in
    "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/" +
    "-/archive/${tag}/nixos-mailserver-${tag}.tar.gz";
  mailserver-sha256 = "1h1r4x2ffqwyk0ql6kjvcpg1bdiimyzhrsvn49702fsgzpx57fhd";

  normal-users = filterAttrs
    (name: conf:
      name != "root" &&
      (conf.name or "") != "root" &&
      (conf.isNormalUser or (! (conf.isSystemUser or false)))
    )
    (
      (configuration.users.users or { }) //
      (configuration.users.extraUsers or { })
    );
  email-accounts = mapAttrs'
    (key: conf:
      let
        email = "${conf.name or key}@func.xyz";
        hashedPassword = conf.hashedPassword or "!";
        quota = "1G";
      in
      nameValuePair
        (trace "serving email ${email}" email)
        { inherit hashedPassword quota; }
    )
    normal-users;

  hostname = configuration.networking.hostName;
  acting-condition = (
    hostname == "lbdot"
  );
in
{

  imports =
    if acting-condition then
      [ (fetchTarball { url = mailserver-url; sha256 = mailserver-sha256; }) ]
    else
      [ ./modules/dummy/mailserver.nix ];

  security.acme = optionalAttrs acting-condition {
    acceptTerms = true;
    defaults.email = "gerald.mouse@func.xyz";
  };

  mailserver = optionalAttrs acting-condition {

    enable = trace "Enable mailserver of SNM" true;
    fqdn = "mail.func.xyz";
    sendingFqdn = "mail.func.xyz";
    domains = [ "func.xyz" ];
    loginAccounts = email-accounts;

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;

    # Enable IMAP, POP3 and SMTP
    enableImap = false;
    enablePop3 = true;
    enableSubmission = true;
    enableImapSsl = false;
    enablePop3Ssl = true;
    enableSubmissionSsl = true;

    # Enable the ManageSieve protocol
    enableManageSieve = false;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;
  };

  services.nginx = optionalAttrs acting-condition {
    virtualHosts."${configuration.mailserver.fqdn}" = { };
  };
}
