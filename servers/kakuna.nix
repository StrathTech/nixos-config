{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../server.nix
      ../ldap.nix
      ../homedirs.nix
      ../binary-cache.nix
      ../lab/master.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  users.motd = lib.mkBefore (builtins.readFile ../motds/kakuna.ansi);

  networking = {
    hostName = "kakuna";
    interfaces.enp4s0.ip4 = [ { address = "130.159.141.112"; prefixLength = 26;} ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
