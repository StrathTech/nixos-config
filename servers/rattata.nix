{ config, pkgs, ... }:

{
  imports =
    [
      ../server.nix
      ../ldap.nix
      ../homedirs.nix
      ../binary-cache.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    hostName = "rattata";
    interfaces.enp4s0.ip4 = [ { address = "130.159.141.75"; prefixLength = 26;} ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
