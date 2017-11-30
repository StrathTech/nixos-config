{ ghc, runCommand }:
runCommand "pxl" {
  buildInputs = [(ghc.withPackages (ps: with ps; [JuicyPixels]))];
} ''
  mkdir -p $out/bin
  ghc ${./pxl.hs} -o $out/bin/pxl
''
