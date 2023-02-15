#!/usr/bin/env sh

echo "
let
  mynix =
"
if [[ -v DEBUG ]];
then echo "
    ./.;
"
else echo "
    builtins.fetchGit {
      url = \"$(pwd)/../.git\";
      rev = \"$(git rev-parse HEAD)\";
    };
"
fi
echo "
in
import (mynix + \"/lbhost\") {
  networking.hostName = \"$(hostname)\";
  imports = [ ./hardware-configuration.nix ];
}
"
