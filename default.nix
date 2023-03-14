{ fetchFromGitHub, runCommandCC, fpc }:

let
  src = fetchFromGitHub {
    owner = "siers";
    repo = "snake";
    rev = "6586e29";
    sha256 = "tshMO1PPq/Q/j/xJOb3VqsvaEWr8i2SJow+xPgaUIAw=";
  };
in
  runCommandCC "siers-snake" {} ''
    cp -r "${src}"/* .
    ls >&2
    export PATH="$PATH:${fpc}/bin"
    make
    mkdir $out
    cp bin/main $out/main
  ''
