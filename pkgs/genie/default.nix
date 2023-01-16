{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, ...
}:

let

  inherit (pkgs.stdenv)
    isDarwin
    isLinux
    isCygwin
    ;
  inherit (builtins)
    fetchGit
    ;
  inherit (lib)
    optional
    ;

  apple-sdk = pkgs.darwin.apple_sdk;
  apple-rtpkgs = optional isDarwin (with apple-sdk.frameworks; [
    CoreServices
  ]);
  apple-patches = optional isDarwin [
    ./darwin.patch
  ];

  stdenv = pkgs.stdenv;

in
stdenv.mkDerivation {
  pname = "GENie";
  version = "1170";
  src = fetchGit {
    url = "https://github.com/bkaradzic/GENie.git";
    rev = "22cc907a4351db46c55f73e6aa901f1b2f0c52ad";
  };
  patches = apple-patches;
  nativeBuildInputs = with pkgs; [ stdenv ];
  buildInputs = apple-rtpkgs;
  buildPhase = ''
    make
  '';
  installPhase = ''
    mkdir -p "$out/bin/"
    cp bin/*/genie "$out/bin/"
  '';
}
