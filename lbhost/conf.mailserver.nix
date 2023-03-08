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
    ;

  mailserver-url =
    let
      vers = splitVersion version;
      tag = "nixos-${elemAt vers 0}.${elemAt vers 1}";
    in
    "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/" +
    "-/archive/${tag}/nixos-mailserver-${tag}.tar.gz";
  mailserver-sha256 = "1h1r4x2ffqwyk0ql6kjvcpg1bdiimyzhrsvn49702fsgzpx57fhd";

  hostname = configuration.networking.hostName;
  acting-condition = (
    hostname == "lbnon"
  );
in
{
  imports =
    if acting-condition then
      [ (fetchTarball { url = mailserver-url; sha256 = mailserver-sha256; }) ]
    else
      [ ./modules/dummy/mailserver.nix ];
  mailserver = optionalAttrs acting-condition {
    enable = trace "Enable mailserver of SNM" true;
    fqdn = "mail.func.xyz";
    domains = [ "func.xyz" ];
    loginAccounts = {
      "demo@func.xyz" = {
        # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
        hashedPassword = "!";
        aliases = [ ];
      };
    };
  };
}
