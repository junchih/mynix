{ configuration
, lib
, ...
}:

let

  inherit (builtins)
    trace
    hasAttr
    getAttr
    ;
  inherit (lib)
    optionalAttrs
    ;

  hostname = configuration.networking.hostName;
  has-ipv6 = configuration.networking.enableIPv6 or false;

  host2domain = {
    lbmsi = "24088207";
    lbnuc = "61687290";
    lbvan = "782fe8f0";
  };

  maybe = optionalAttrs (
    has-ipv6 &&
    (hasAttr hostname host2domain)
  );

in
{
  imports = [ ./modules ];
  services.duckdns = optionalAttrs has-ipv6 {
    enable = trace "Enabled duckdns updater for ipv6 only" true;
    ipv4 = false;
    ipv6 = true;
    domain = getAttr hostname host2domain;
  };
}
