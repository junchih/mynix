{ configuration
, lib
, ...
}:

let
  inherit (lib)
    optionals
    ;
  hostname = configuration.networking.hostName;
in
{
  boot.supportedFilesystems =
    optionals (hostname == "nuc-pri" || hostname == "msi-pri") [ "ntfs" "apfs" ];
}
