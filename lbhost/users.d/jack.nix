{ configuration
, lib
, pkgs
, ...
}:

let

  inherit (lib)
    optionals
    ;
  hostname = configuration.networking.hostName;
  has-X = configuration.services.xserver.enable or false;

in
{
  description = "Jack Mao";
  isNormalUser = true;
  createHome = true;
  useDefaultShell = true;
  extraGroups = [ "wheel" ];
  packages = with pkgs;
    # normal life
    [ wget curl croc tree dnsutils unzip unrar gnutar ] ++
    # devel environment
    [ direnv git gnumake ctags ] ++
    (optionals has-X
      [ alacritty vlc ]
    ) ++
    (optionals (hostname == "lbmsi")
      [ nvtop /*cudatoolkit*/ ]
    );

  hashedPassword = "$6$tuw/Fyhe6sY$8v4nfQ/1Cj.JNB8POt/N9ozwMdKt3RSCB7yOFfnbBAWw0Erhl5YoWHOM0W0Jy0HvtjCN.rTfJnVf7geEz/2UX0";

  openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWxW3lz6KBoHGmJ52CtN7hSMy6fZ/8ebu4qCGwfHhuQ/D9XoOHZNrKmrczEdqCQ0PJoJeUPMYMnpFWRnrCP1MDD/XpeUl74mwyP1g7gBUurxaqgsRaCOCpWC6XowRUpYlVULbsFLYU1YwuJbf4uU1loSdmY0oNQ6BYwkACr3nloJwvLUI96x3nECsg9e9dTH8xC1s4ywUB4Ep+Bvj+jrouD8Qe4EtCm4Yl/9pKqeuviWrdtwJM+ZuSvWJi4fd8CJ+F1Wa9eY8TMCq9K3jsp46juCTLaJhDoOAnUPLo01J8n9B+3qavvu3E0kYNmBbFHEKG1741Q43GsEjMsF0/iO0X jack@lbpro"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMgnEux6W5po8vg5rGX8cGccjrH9/3HV989AqKZGGz9S5+yYkssTM0afl8xyOOzv5119IVbxOJGyC3csCpeEi1EXBFp70ChQ47gRhoEElCwb59l0f7PHGmnvSjhlb3FyiKv/Inc0aQ3ZqDP+eWQWRGcYkJnOwJpcohtAZcPP58rHGBPyDwSOnNztL5gLU704txDe1rdLfzlz2VxFCkCd3jeYZhn01jPaQUIBiZ+LzoLTeOs30Wuh0OEeqml3ZEkx5/CR4aNDCDczn01LIswKQuwMXQ80QhZD9ZdKeJwRndhIf0FfYuCiTdiB6mv6aeW7UnBvF3mSyg5L9FWGIhccusBwIxcL7DuJFQKXny2J0/6ydHF20eMX1XL7UsGjMjyrg0r6JASf9r9LajzZQ0LMR9kaZwdlmVJJR48UWxhYW3gbEa/VqQpCg7DqYpX2kMdcYnxRA/htGmAyBst5O5IyoY9shxQs0jsimY/ua3Xw/Tfcfcu9WTfYTyyhkFYLnJpP8= jack@lbnuc"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbFW8nujZimppyHLUrKQLdSvK0WX/oInGsvAyjd8eypg6nMKTGE1olE222t59hgVfANfH0NrXuTkrh/hA4UXz8pIlLhe8aqKXBSaDQmLe+lG/ixeAIO6Pv/ji9/EdlKIa4tz3I7GoFmY32FeNj7k8ENaZfEFXjIeab3gQ1E4LV1GOiCXaVfwtx9kjSfGjW4oTT0oG2o4N5ZvCOR1iggTEJCfQBQ/bog7RG66xw9ORzJgcCpGyJHweN2sOY8eoAG6bRdcUZgQAISccOQvi9Km1mNnZ/bpSXjQvDyRl+PVOxMdzO/vlk8m5lckFarbpw4LTyx/xEmDz9fYlFnxb51hCbH/6JcIQhBdscTswhofrYYRCHQ8TtIE2OM7PU14pzQpYVOmdbcHx5LLRAe04pA93ayCIIIPE4RAKb6BFJM5eQ4NNQrglvNFSGpmIzkgQV0OgavX+1u09iwNrS09m/w4T/RRN1NWbUXYGMDXhMtvNnDFXBGmDCQoayUCl8zRFh1rc= jack@lbmsi"
  ];
}
