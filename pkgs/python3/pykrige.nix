{ pkgs ? import <nixpkgs> { }
, ...
}:

let

  inherit (pkgs.python3.pkgs)
    buildPythonPackage
    fetchPypi
    ;

in
buildPythonPackage rec {
  pname = "PyKrige";
  version = "1.7.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yBS2XwD1Wy7eebUhMphaKgAVuLOXNBk44n7VOiS8Y94=";
  };
  nativeBuildInputs = with pkgs.python3.pkgs; [
    cython
  ];
  propagatedBuildInputs = with pkgs.python3.pkgs; [
    numpy
    scipy
  ];
}
