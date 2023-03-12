#!/usr/bin/env sh

echo "
let
  mynix =
"
if [[ -v RELEASE ]];
then echo "
    builtins.fetchTarball (
      \"https://github.com/junchih/mynix/archive/\" +
      \"$(git rev-parse HEAD)\" +
      \".tar.gz\"
    );
"
else echo "
    $(pwd)/..;
"
fi
echo "
in
{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./vault.nix
    (mynix + "/lbhost/$(hostname).nix")
  ];
})
"
