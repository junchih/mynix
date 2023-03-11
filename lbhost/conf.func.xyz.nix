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
    hostname == "lbvan"
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
      root = "/var/www/func.xyz";
    };
  };
}
