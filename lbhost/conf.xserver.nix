{ configuration
, lib
, pkgs
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
    hostname == "lbmsi"
  );

in

{
  services.xserver = maybe {
    # Enable the X11 windowing system.
    enable = trace "Enable X11 windowing system" true;
    # Enable the Desktop Environments.
    displayManager.lightdm.enable = true;
    displayManager.lightdm.greeters.pantheon.enable = true;
    desktopManager.pantheon.enable = true;
  };
  environment.pantheon = maybe {
    excludePackages = with pkgs.pantheon; [
      touchegg
      sideload
      epiphany
      appcenter
      elementary-videos
      elementary-music
      elementary-photos
      elementary-mail
      elementary-calendar
      elementary-tasks
      elementary-calculator
      elementary-code
      elementary-screenshot
      elementary-camera
      elementary-feedback
      elementary-sound-theme
      elementary-print-shim
      elementary-onboarding
      elementary-iconbrowser
    ];
  };
}
