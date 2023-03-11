{ configuration
, lib
, ...
}:

let
  inherit (builtins)
    trace
    ;
  inherit (lib)
    optionalAttrs
    ;
  hostname = configuration.networking.hostName;

  maybe = optionalAttrs (
    hostname == "none"
  );
in
{
  security.acme = maybe {
    acceptTerms = true;
    certs = {
      "func.xyz".email = "thomas.cat@func.xyz";
    };
  };

  services.nginx = maybe {
    enable = trace "Serving func.xyz" true;
    virtualHosts."func.xyz" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/func.xyz";
    };
  };
}
