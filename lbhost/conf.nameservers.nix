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
    hasInfix
    ;
  hostname = configuration.networking.hostName;
  has-ipv6 = configuration.networking.enableIPv6 or false;

  plain-dns = [ "1.1.1.1" "1.0.0.1" ] ++
    (optionals has-ipv6 [ "2606:4700:4700::1111" "2606:4700:4700::1001" ]);
  crypt-dns = [ "127.0.0.1" ] ++ (optionals has-ipv6 [ "::1" ]);

  maybe = optionalAttrs (
    hostname == "msi-pri" ||
    hostname == "nuc-pri"
  );

in
{
  services.dnscrypt-proxy2 = maybe {
    enable = trace "Using Crypted DNS" true;
    upstreamDefaults = true;
    settings = {
      listen_addresses = map
        (ip: if hasInfix ":" ip then "[${ip}]:53" else "${ip}:53")
        crypt-dns;
      bootstrap_resolvers = map
        (ip: if hasInfix ":" ip then "[${ip}]:53" else "${ip}:53")
        plain-dns;
      lb_strategy = "p3";
      lb_estimator = true;
      ipv4_servers = true;
      ipv6_servers = has-ipv6;
      dnscrypt_servers = true;
      doh_servers = true;
      require_dnssec = false;
      require_nolog = false;
      require_nofilter = true;
      disabled_server_names = [ ];
    };
  };

  networking.nameservers =
    if configuration.services.dnscrypt-proxy2.enable or false then
      crypt-dns
    else
      plain-dns;
}
