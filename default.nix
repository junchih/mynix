{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, ...
}@args:

import ./pkgs { inherit pkgs lib; }
