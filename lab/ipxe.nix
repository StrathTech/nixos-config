{ ipxe, writeText
, ipxeScript ? writeText "boot.ipxe" ''
  #!ipxe
  dhcp || dhcp || dhcp || dhcp || dhcp || shell
  chain http://netboot.strathtech.co.uk/boot.ipxe || shell
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
