{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib)
    mkOption
    mdDoc
    types
    ;
in
{
  options.mailserver = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Dummy flag
      '';
    };
  };
}
