{ pkgs ? import <nixpkgs> {}
, ...
}:

let

  inherit (pkgs.stdenv)
    mkDerivation
  ;

in mkDerivation rec {
  pname = "squish";
  version = "0.2.0";
  src = fetchGit {
    url = "https://github.com/junchih/squish.git";
    ref = "master";
    rev = "53ef6bd4cf2c0a644e7bf8c1078d421169cba564";
  };
  buildInputs = with pkgs; [ luajit ];
  buildPhase = ''
    make squish
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    cp squish make_squishy "$out/bin/"
  '';
}
