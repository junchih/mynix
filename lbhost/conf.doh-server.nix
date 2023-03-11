{ config
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
  hostname = config.networking.hostName;

  maybe = optionalAttrs (
    hostname == "van-vc2"
  );

in

{
  security.acme = maybe {
    acceptTerms = true;
    certs = {
      "internal.sg.baidu-ai.func.xyz".email = "junchih.1893@gmail.com";
    };
  };

  services.nginx = maybe {
    enable = trace "Serving internal.sg.baidu-ai.func.xyz" true;
    virtualHosts."internal.sg.baidu-ai.func.xyz" = {
      default = true;
      forceSSL = true;
      enableACME = true;
      root = "/var/www/internal.sg.baidu-ai.func.xyz";
      locations."/".return = "301 https://www.baidu.com$request_uri";

      locations."/dG91Y2ggbWUsIGphY2subWFvQGZ1bmMueHl6/doh-cf".proxyPass = "https://cloudflare-dns.com/dns-query";
      locations."/dG91Y2ggbWUsIGphY2subWFvQGZ1bmMueHl6/doh-88".proxyPass = "https://dns.google/dns-query";
      locations."/dG91Y2ggbWUsIGphY2subWFvQGZ1bmMueHl6/doh-q9".proxyPass = "https://dns10.quad9.net/dns-query";
    };
  };
}
