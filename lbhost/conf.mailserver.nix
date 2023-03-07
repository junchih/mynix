{ configuration
, lib
, ...
}:

let

  inherit (builtins)
    trace
    eleAt
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
      tag = "nixos-${eleAt vers 0}.${eleAt vers 1}";
    in
    "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/" +
    "-/archive/${tag}/nixos-mailserver-${tag}.tar.gz";
  mailserver-sha256 = "";

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
  mailserver = optionalAttrs acting-condition {
    enable = trace "Enable mailserver of SNM" true;
    fqdn = "mail.func.xyz";
    domains = [ "func.xyz" ];
    loginAccounts = {
      "demo@func.xyz" = {
        # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
        hashedPassword = "!";
        alias = [ ];
      };
    };
    certificateScheme = 3;
  };
}
