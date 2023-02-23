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
    optionals (hostname == "lbnuc" || hostname == "lbmsi") [ "ntfs" "apfs" ];
}
