{ pkgs ? import <nixpkgs> {}
, ...
}@args:

let

  mylib  = import ./lib args;
  mypkgs = import ./pkgs (args // {inherit mylib;});

in mylib // mypkgs
