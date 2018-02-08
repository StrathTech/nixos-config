{ ipxe, writeText
, ipxeScript ? writeText "boot.ipxe" ''
  #!ipxe
  dhcp
  chain http://netboot.strathtech.co.uk/boot.ipxe
''
}:
ipxe.overrideAttrs (o: {
  makeFlags = o.makeFlags ++ [ "EMBED=${ipxeScript}" "bin/undionly.kpxe" ];
  installPhase = ''
    mkdir -p $out
    cp bin/undionly.kpxe $out/
  '';
  enableParallelBuilding = true;
})
