{ configuration
, lib
, ...
}:

let

  inherit (builtins)
    trace
    ;
  inherit (lib)
    optionals
    optionalAttrs
    ;
  hostname = configuration.networking.hostName;
  has-ipv6 = configuration.networking.enableIPv6 or false;

  maybe = optionalAttrs (
    hostname == "lbmsi" ||
    hostname == "lbnuc"
  );

in
{
  services.dnscrypt-proxy2 = maybe {
    enable = trace "Using DoH client" true;
    settings = {
      listen_addresses = [ "127.0.0.1:53" ];
      ipv6_servers = has-ipv6;
      server_names = [
        "cloudflare"
        "google"
      ] ++ (optionals has-ipv6 [
        "cloudflare-ipv6"
        "google-ipv6"
      ]);
      bootstrap_resolvers = [ "1.1.1.1:53" "1.0.0.1:53" ];
    };
  };

  networking.nameservers =
    if configuration.services.dnscrypt-proxy2.enable or false then
      [ "127.0.0.1" ]
    else
      [ "1.1.1.1" "1.0.0.1" ];
}
