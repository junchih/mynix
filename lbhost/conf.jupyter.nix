{ config
, pkgs
, lib
, ...
}:

let

  inherit (builtins)
    trace
    toString
    ;
  inherit (lib)
    optionals
    optionalAttrs
    ;

  hostname = config.networking.hostName;
  local-host = "127.0.0.1";
  local-port = 8000;
  maybe = optionalAttrs (
    hostname == "msi-pri"
  );

  ipy3sci = pkgs.python3.withPackages (pyPkgs: with pyPkgs; [
    ipykernel
    matplotlib
    numpy
    scipy
    scikit-learn
    tensorflow
  ]);

in
{

  services.jupyterhub = maybe {

    enable = trace "Enable jupyterhub service" true;
    authentication = "jupyterhub.auth.PAMAuthenticator";
    host = local-host;
    port = local-port;

    kernels.ipy3sci = {
      displayName = "Python 3 for Scientific";
      language = "python3";
      logo32 = "${ipy3sci}/${ipy3sci.sitePackages}/ipykernel/resources/logo-32x32.png";
      logo64 = "${ipy3sci}/${ipy3sci.sitePackages}/ipykernel/resources/logo-64x64.png";
      argv = [
        "${ipy3sci.interpreter}"
        "-m"
        "ipykernel_launcher"
        "-f"
        "{connection_file}"
      ];
    };
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
