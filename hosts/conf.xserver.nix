{ configuration, lib, ... }:
let

  inherit (builtins) trace;
  inherit (lib) optionalAttrs;

  hostname = configuration.networking.hostName;

  maybe-attrs = optionalAttrs (
    hostname == "lbnuc" ||
    hostname == "lbmsi"
  );

in

{
  services.xserver = maybe-attrs {
    # Enable the X11 windowing system.
    enable = trace "Enable X11 windowing system" true;
    resolutions = [
      { x = 1920; y = 1080; }
    ];
    # Enable the Desktop Environments.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
}
