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
    [ dnsutils ] ++
    # devel environment
    [ direnv git gnumake ctags ] ++
    (optionals has-X
      [ alacritty ]
    ) ++
    (optionals (hostname == "lbmsi")
      [ nvtop /*cudatoolkit*/ ]
    );

  hashedPassword = "$y$j9T$CWXs5NEnz1kfkeNP/HK7X0$pZmGawGlwQ7/LsfLUAp96jMQnNNbyCmzt5I/8SAemp.";

  openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWxW3lz6KBoHGmJ52CtN7hSMy6fZ/8ebu4qCGwfHhuQ/D9XoOHZNrKmrczEdqCQ0PJoJeUPMYMnpFWRnrCP1MDD/XpeUl74mwyP1g7gBUurxaqgsRaCOCpWC6XowRUpYlVULbsFLYU1YwuJbf4uU1loSdmY0oNQ6BYwkACr3nloJwvLUI96x3nECsg9e9dTH8xC1s4ywUB4Ep+Bvj+jrouD8Qe4EtCm4Yl/9pKqeuviWrdtwJM+ZuSvWJi4fd8CJ+F1Wa9eY8TMCq9K3jsp46juCTLaJhDoOAnUPLo01J8n9B+3qavvu3E0kYNmBbFHEKG1741Q43GsEjMsF0/iO0X jack@lbpro"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbFW8nujZimppyHLUrKQLdSvK0WX/oInGsvAyjd8eypg6nMKTGE1olE222t59hgVfANfH0NrXuTkrh/hA4UXz8pIlLhe8aqKXBSaDQmLe+lG/ixeAIO6Pv/ji9/EdlKIa4tz3I7GoFmY32FeNj7k8ENaZfEFXjIeab3gQ1E4LV1GOiCXaVfwtx9kjSfGjW4oTT0oG2o4N5ZvCOR1iggTEJCfQBQ/bog7RG66xw9ORzJgcCpGyJHweN2sOY8eoAG6bRdcUZgQAISccOQvi9Km1mNnZ/bpSXjQvDyRl+PVOxMdzO/vlk8m5lckFarbpw4LTyx/xEmDz9fYlFnxb51hCbH/6JcIQhBdscTswhofrYYRCHQ8TtIE2OM7PU14pzQpYVOmdbcHx5LLRAe04pA93ayCIIIPE4RAKb6BFJM5eQ4NNQrglvNFSGpmIzkgQV0OgavX+1u09iwNrS09m/w4T/RRN1NWbUXYGMDXhMtvNnDFXBGmDCQoayUCl8zRFh1rc= jack@lbmsi"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEaT5SYYRI03TCwO8yJAB51AJTcK365GlIsftwU4LcJTX1EEc/Jgk70qYjiRcwdrZdX1ziQlDbEmAPqh4gM7DoIb1iz81hWhj63BXCWLvROwVya/XaKPggmr9pTK0nDNqsAqsUyp2HZYauGKxFp9Lnz1R/u7EYPV5XD2Ka2udt4aHthWYNJvdLEUJuDrDMz5DRKjEL6d88X+7Of8Pa7SgHy9qxzfZ6k5DJLRzmX6rwpZsPM0NjFPRxWb5ZthpnkUFXaBhO16xqIZxw0OYkr5+NG9NZcoLMUTxpJsEpx/Qng3EQvb6HLeY1fjD+bhgJ+Vl3N2eJ7nKbyT+A/oVBQeQvzWn2E3P84hDiRY3UZuPFy1O58ydgOR7csHIxEZWgs2uj3VS/BeSburc5dzEQB8YNLfXjpc2CYaghB/z97u7JdIqpzrJ/ta/J2M/+qBTq0usabPP5cSxo7lREHLZT7KTPGH/DvhGIuBgysrEW2o8oe51U1mSanX7ulur7ssrwoJM= jack@lbvan"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkcQTBFBbdgMG1O1QJuphK34CxznoCOa14xe8AclPkPCgPrsiMY5/m06lM2T4CQIUkfsa5GqkAqM30IepXKzkJNiTf+86Pf6uJPIxGc6Bs1F9AnOz411g0+1AWbIamt0EHHxI3/zumoB7wg/GJuYzPslmvxdF6QCtdIX4wg8AM8YIF/9YFgKKT+sYW/Mr1vF7iNETZAK4I6+1Wugo/sd7Hh+pRbPMxOw+cpLsae3XGG2kVXIv2zRvxVyCkoAQ/SQ0J44suCCmiW4uCskGpvO6aAKNWLYbJ6T5cLSwHe09rzitB90nO7NawrCNqjRTnPifOIVBDAdYKMgekmr1YQFZjzrr1OsKZdsLe1ZbnYUrkkl7Cu26+ZA2itvUW/EPTU5/5reTkj7gRx9XlkZwk7qZj3UPPn3w/+c7AL/tQkC/Qnhh2+YKSp04e1AuWYXaVLEAu5DbgMarhF4yeGfxCY8yZxxQHpIEGcwtvdStvt3KSmj7mgMcnwmpLvxDuEIg4usk= jack@lbnuc"
  ];
}
