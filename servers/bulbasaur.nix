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
    hostName = "bulbasaur.strathtech.co.uk";
    interfaces.enp4s0.ip4 = [ { address = "130.159.141.71"; prefixLength = 26;} ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";
}
