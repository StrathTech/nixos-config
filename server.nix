{ config, pkgs, ... }:
{
  imports = [ /etc/nixos/hardware-configuration.nix ./global.nix ];
  networking.defaultGateway = {address = "130.159.141.126";};
  networking.domain = "strathtech.co.uk";
  networking.nameservers = [ "130.159.141.73" "130.159.141.74" ];

  boot.loader.grub.splashImage = null;
}
