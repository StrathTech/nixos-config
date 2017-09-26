{ config, pkgs, ... }:
{
  imports = [ ./global.nix ];
  networking.defaultGateway = {address = "130.159.141.126"; interface = "enp4s0";};
  networking.nameservers = [ "130.159.141.73" "130.159.141.74" ];
}
