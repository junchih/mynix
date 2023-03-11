{ config
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

  hostname = config.networking.hostName;
  has-ipv6 = config.networking.enableIPv6 or false;
  duckdns-token = config.services.duckdns.token or "";
  has-token = duckdns-token != "";

  host2domain = {
    "msi-pri" = "24088207";
    "nuc-pri" = "61687290";
  };

  maybe = optionalAttrs (
    has-ipv6 &&
    (hasAttr hostname host2domain)
  );

in
{
  imports = [
    ./modules/services/duckdns.nix
  ];
  services.duckdns = maybe {
    enable =
      if has-token then
        trace "Enabled duckdns updater for ipv6 only" true
      else
        trace "Disabled duckdns updater, missing token" false
    ;
    ipv4 = false;
    ipv6 = true;
    domain = getAttr hostname host2domain;
  };
}
