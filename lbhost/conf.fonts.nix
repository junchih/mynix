{ configuration
, pkgs
, lib
, ...
}:

let
  inherit (lib)
    optionalAttrs
    ;
  has-X = configuration.services.xserver.enable or false;
in
{
  fonts = optionalAttrs has-X {
    fonts = with pkgs; [
      fira-code
      hanazono
    ];
  };
}
