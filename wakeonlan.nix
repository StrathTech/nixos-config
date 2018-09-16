{ config, pkgs, ... }:
let enable-all = pkgs.writeScript "enable-wol" ''
  #!${pkgs.stdenv.shell}
  set -x +e
  for iface in /sys/class/net/* ; do
    ${pkgs.ethtool}/bin/ethtool -s "''${iface##*/}" wol g
  done
'';
in {
  powerManagement.powerDownCommands = "${enable-all}";
  systemd.services.wol = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    requires = ["network.target"];
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${enable-all}";
  };
}
