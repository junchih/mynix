{ config
, lib
, ...
}:

let
  inherit (lib)
    optionals
    ;
  hostname = config.networking.hostName;
in
{
  boot.supportedFilesystems =
    optionals (hostname == "nuc-pri" || hostname == "msi-pri") [ "ntfs" "apfs" ];
}
