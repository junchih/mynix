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
    hostname == "lbdot"
  );
in
{
  security.acme = maybe {
    acceptTerms = true;
    certs = {
      "func.xyz".email = "gerald.mouse@func.xyz";
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
