{ stdenv, ... }:
stdenv.mkDerivation {
  pname = "nixbits";
  version = "0.1.4";

  src = ./nixbits.sh;

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/nixbits
    chmod +x $out/bin/nixbits
  '';
}
