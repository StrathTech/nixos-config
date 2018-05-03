{ config, pkgs, ... }:

{
  imports =
    [
      ../server.nix
      ../ldap.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "zfs" ];

  networking = {
    hostId = "6d657774";
    hostName = "mewtwo";
    interfaces.ext.ipv4.addresses = [ { address = "130.159.141.100"; prefixLength = 26;} ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:30:05:fc:5e:62", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="ext"
  '';
  boot.loader.grub.useOSProber = true;
}
