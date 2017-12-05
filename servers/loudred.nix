{ config, pkgs, ... }:

{
  imports =
    [
      ../server.nix
      ../ldap.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    hostName = "loudred";
    interfaces.enp2s0f0.ip4 = [ { address = "130.159.141.76"; prefixLength = 26;} ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
