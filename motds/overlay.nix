self: super: {
  pxl = super.callPackage ./pxl.nix {};
  imageToAnsi = name: image: super.runCommand name { buildInputs = [ self.pxl ]; } ''
    export LOCALE_ARCHIVE=${self.glibcLocales}/lib/locale/locale-archive
    export LANG=en_US.UTF-8
    pxl ${image} > $out
  '';
}
