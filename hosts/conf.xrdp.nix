{ configuration, lib, ... }:
let

  inherit (builtins) trace;
  inherit (lib) optionalAttrs;

  hostname = configuration.networking.hostName;
  has-xserver = configuration.services.xserver.enable or false;

  maybe-attrs = optionalAttrs (
    has-xserver &&
    (
      hostname == "lbnuc" ||
      hostname == "lbmsi"
    )
  );

in

{
  services.xrdp = maybe-attrs {
    enable = trace "Enable RDP service" true;
    defaultWindowManager = "startplasma-x11";
  };
}
