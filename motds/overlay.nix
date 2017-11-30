self: super: {
  pxl = super.callPackage ./pxl.nix {};
  imageToAnsi = name: image: super.runCommand name { buildInputs = [ self.pxl ]; } ''
    pxl ${image} > $out
  '';
}
