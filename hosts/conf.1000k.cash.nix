{ configuration, lib, ... }:
let

  inherit (builtins) trace;
  inherit (lib) optionalAttrs;

  hostname = configuration.networking.hostName;

  maybe-attrs = optionalAttrs (
    hostname == "lbvan"
  );

in

{
  security.acme = maybe-attrs {
    acceptTerms = true;
    certs = {
      "1000k.cash".email = "shushu90@mail.func.xyz";
    };
  };

  services.nginx = maybe-attrs {
    enable = trace "Serving 1000k.cash" true;
    virtualHosts."1000k.cash" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/1000k.cash";
    };
  };
}
