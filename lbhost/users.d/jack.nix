{ config
, lib
, pkgs
, ...
}:

let

  inherit (lib)
    optionals
    ;
  hostname = config.networking.hostName;
  has-X = config.services.xserver.enable or false;

in
{
  description = "Jack Mao";
  isNormalUser = true;
  createHome = true;
  useDefaultShell = true;
  extraGroups = [ "wheel" "git" ];
  packages = with pkgs;
    # normal life
    [ dnsutils ] ++
    # devel environment
    [ direnv git gnumake ctags ] ++
    (optionals has-X
      [ alacritty ]
    ) ++
    (optionals (hostname == "msi-pri")
      [ nvtop cudatoolkit ]
    );

  hashedPassword = "$y$j9T$CWXs5NEnz1kfkeNP/HK7X0$pZmGawGlwQ7/LsfLUAp96jMQnNNbyCmzt5I/8SAemp.";
  openssh.authorizedKeys.keys = lib.splitString "\n"
    (builtins.readFile ./junchih.github.keys);
}
