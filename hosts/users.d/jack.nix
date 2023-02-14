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
  has-xserver = configuration.services.xserver.enable or false;

in

{
  description = "Jack Mao";
  isNormalUser = true;
  createHome = true;
  useDefaultShell = true;
  extraGroups = [ "wheel" ];
  packages = with pkgs; [

    # normal life
    wget
    curl
    croc
    tree
    dnsutils
    unzip
    unrar
    gnutar

    # development environment
    direnv
    git
    gnumake
    ctags

  ] ++ (optionals has-xserver [

    alacritty

  ]) ++ (optionals (hostname == "lbmsi") [

    nvtop
    #cudatoolkit

  ]);

  hashedPassword = "$6$tuw/Fyhe6sY$8v4nfQ/1Cj.JNB8POt/N9ozwMdKt3RSCB7yOFfnbBAWw0Erhl5YoWHOM0W0Jy0HvtjCN.rTfJnVf7geEz/2UX0";

  openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWxW3lz6KBoHGmJ52CtN7hSMy6fZ/8ebu4qCGwfHhuQ/D9XoOHZNrKmrczEdqCQ0PJoJeUPMYMnpFWRnrCP1MDD/XpeUl74mwyP1g7gBUurxaqgsRaCOCpWC6XowRUpYlVULbsFLYU1YwuJbf4uU1loSdmY0oNQ6BYwkACr3nloJwvLUI96x3nECsg9e9dTH8xC1s4ywUB4Ep+Bvj+jrouD8Qe4EtCm4Yl/9pKqeuviWrdtwJM+ZuSvWJi4fd8CJ+F1Wa9eY8TMCq9K3jsp46juCTLaJhDoOAnUPLo01J8n9B+3qavvu3E0kYNmBbFHEKG1741Q43GsEjMsF0/iO0X jack@lbpro"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMgnEux6W5po8vg5rGX8cGccjrH9/3HV989AqKZGGz9S5+yYkssTM0afl8xyOOzv5119IVbxOJGyC3csCpeEi1EXBFp70ChQ47gRhoEElCwb59l0f7PHGmnvSjhlb3FyiKv/Inc0aQ3ZqDP+eWQWRGcYkJnOwJpcohtAZcPP58rHGBPyDwSOnNztL5gLU704txDe1rdLfzlz2VxFCkCd3jeYZhn01jPaQUIBiZ+LzoLTeOs30Wuh0OEeqml3ZEkx5/CR4aNDCDczn01LIswKQuwMXQ80QhZD9ZdKeJwRndhIf0FfYuCiTdiB6mv6aeW7UnBvF3mSyg5L9FWGIhccusBwIxcL7DuJFQKXny2J0/6ydHF20eMX1XL7UsGjMjyrg0r6JASf9r9LajzZQ0LMR9kaZwdlmVJJR48UWxhYW3gbEa/VqQpCg7DqYpX2kMdcYnxRA/htGmAyBst5O5IyoY9shxQs0jsimY/ua3Xw/Tfcfcu9WTfYTyyhkFYLnJpP8= jack@lbnuc"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5u7V3Ld8g1MxmmtyQ/vfhjGo5+CNrTgF4RTjfXMCSfqoc6sg7oSOkUjhHkk463Kkc1GbxFZSxYfFg9MnzlSdvCWOUhH3f5d4FQhtHxCDA5dtq4XXzr92Cn9UfMW3tX+YC7gxOBXPi1jW6seDUY0tudq9iP8E6+7q08Hw71YmlWMByeKtNo9elo1V4hTWIkS57rAlE5WbTM3Qlu2B8aXTQj2t4am4wlHtk2tFBTvTMR4zTWR+dJgnaqjeIRhQzlQ2rllyAJPq3L422BbMQK30yXIHpYO2rpzeBSOxsJRwaK6fypL+XcaI39yPmOeY5CHkkhtla3YYbv3aa4zrl2+Gnuui0Ad5LkDMpqt2GoorNC1yJ9coAqcvj4eQiWD4HXP3sJ4kfNaLlCOyZENtgFJSrkaZm2eWPl94DKtPvakYv7AX9lPWojX9KxfHWvOyBs7F1zD2MmAGTLkrmAqOQZf0B6zti557+Gi6Ze6Bx1dZ5bUva4Ol2vF61RAqxPk5RrwU= jack@lbmsi"
  ];
}
