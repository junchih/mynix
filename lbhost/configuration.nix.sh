#!/usr/bin/env sh

echo "
let
  mynix =
"
if [[ -v RELEASE ]];
then echo "
    fetchTarball
      \"https://github.com/junchih/mynix/archive/\" +
      \"$(git rev-parse HEAD)\" +
      \".tar.gz\";
"
else echo "
    $(pwd)/..;
"
fi
echo "
in
import (mynix + \"/lbhost\")
({ config, pkgs, lib, ... }: {
  networking.hostName = \"$(hostname)\";
  imports = [ ./hardware-configuration.nix ];
})
"
