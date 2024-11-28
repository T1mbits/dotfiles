{ stdenv, ... }:
stdenv.mkDerivation rec {
  pname = "nixbits";
  version = "0.1.1";

  src = ../scripts/nixbits.sh;

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/nixbits
    chmod +x $out/bin/nixbits
  '';
}
