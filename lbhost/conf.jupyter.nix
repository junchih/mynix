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

  ipy3-pkgs = py-pkgs: with py-pkgs; [
    ipykernel
    matplotlib
    numpy
    scipy
    scikit-learn
    tensorflow
  ];
  ihask-pkgs = hs-pkgs: with hs-pkgs; [
    ihaskell
    lens
  ];

in
{

  services.jupyterhub = maybe {

    enable = trace "Enable jupyterhub service" true;
    authentication = "jupyterhub.auth.PAMAuthenticator";
    host = local-host;
    port = local-port;

    kernels.ipy3-sci =
      let ipy3 = pkgs.python3.withPackages ipy3-pkgs;
      in {
        displayName = "Python3 for Sci";
        language = "python3";
        argv = [
          "${ipy3.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
      };
    kernels.ihask-cs =
      let hask = pkgs.haskellPackages.ghcWithPackages ihask-pkgs;
      in {
        displayName = "Haskell for CS";
        language = "haskell";
        argv = [
          "${hask}/bin/ihaskell"
          "kernel"
          "-l"
          "${hask}/lib/ghc-${hask.version}"
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
