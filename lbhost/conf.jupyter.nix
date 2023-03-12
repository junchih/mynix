{ config
, lib
, ...
}:

let
  inherit (builtins)
    trace
    toString
    ;
  inherit (lib)
    optionalAttrs
    ;
  hostname = config.networking.hostName;
  local-host = "127.0.0.1";
  local-port = 8000;
  maybe = optionalAttrs (
    hostname == "msi-pri"
  );
in
{
  services.jupyterhub = maybe {
    enable = trace "Enable jupyterhub service" true;
    authentication = "jupyterhub.auth.PAMAuthenticator";
    host = local-host;
    port = local-port;
  };
  security.acme = maybe {
    acceptTerms = true;
    certs = {
      "jupyter.func.xyz".email = "thomas.cat@func.xyz";
    };
  };
  services.nginx = maybe {
    enable = trace "Serving jupyter.func.xyz" true;
    virtualHosts."jupyter.func.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://${local-host}:${toString local-port}$request_uri";
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
        '';
      };
    };
  };
}
