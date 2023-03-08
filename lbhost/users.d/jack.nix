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
  openssh.authorizedKeys.keys = lib.splitString "\n"
    (builtins.readFile ./junchih.github.keys);
}
