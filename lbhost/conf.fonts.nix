{ config
, pkgs
, lib
, ...
}:

let
  inherit (lib)
    optionalAttrs
    ;
  has-X = config.services.xserver.enable or false;
in
{
  fonts = optionalAttrs has-X {
    fonts = with pkgs; [
      fira-code
      hanazono
    ];
  };
}
