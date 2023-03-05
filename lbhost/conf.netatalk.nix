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

  maybe-attrs = optionalAttrs (
    hostname == "lbmsi" || hostname == "lbnuc"
  );

in
{
  services.netatalk = maybe-attrs {
    enable = trace "Enable Netatalk service" true;
    settings = {
      Global = {
        "mimic model" = "Xserve3,1";
      };
      Homes = {
        "basedir regex" = "/home";
        "path" = "Shared";
        "hosts allow" = "192.168.132.0/24 172.19.132.0/24";
      };
    };
  };
}
