{ pkgs ? import <nixpkgs> {}
, ...
}:

let

  inherit (pkgs.stdenv)
    mkDerivation
  ;
  inherit (builtins)
    fetchGit
  ;

in mkDerivation rec{

  pname = "rtklib";
  version = "2.4.2-p13";

  src = fetchGit {
    url = "https://github.com/tomojitakasu/RTKLIB.git";
    ref = "refs/tags/v${version}";
  };

  buildInputs = with pkgs; [ stdenv ];
  # FIXME Build will fail. Linking flag `-lrt` will failed on Mac OS, which
  # specified in makefile of each binary.
  buildPhase = ''
    ( \
      cd app/pos2kml/gcc && \
      make pos2kml \
    )
    ( \
      cd app/str2str/gcc && \
      make str2str \
    )
    ( \
      cd app/rnx2rtkp/gcc && \
      make rnx2rtkp \
    )
    ( \
      cd app/convbin/gcc && \
      make convbin \
    )
    ( \
      cd app/rtkrcv/gcc && \
      make rtkrcv \
    )
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    cp app/pos2kml/gcc/pos2kml "$out/bin/rtk-pos2kml"
    cp app/str2str/gcc/str2str "$out/bin/rtk-str2str"
    cp app/rnx2rtkp/gcc/rnx2rtkp "$out/bin/rtk-rnx2rtkp"
    cp app/convbin/gcc/convbin "$out/bin/rtk-convbin"
    cp app/rtkrcv/gcc/rtkrcv "$out/bin/rtk-rtkrcv"
  '';
}
