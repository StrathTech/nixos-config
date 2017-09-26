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
    hostName = "kakuna";
    interfaces.enp4s0.ip4 = [ { address = "130.159.141.112"; prefixLength = 26;} ];
    defaultGateway = {address = "130.159.141.126"; interface = "enp4s0";};
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";
}
