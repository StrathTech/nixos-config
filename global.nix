{ config, pkgs, lib, ... }:
{
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  time.timeZone = "Europe/London";

  # Linus's YubiKey
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDf7hGFfUHhtgYY0G/Dh9isjIxkvUjlAKAMvLIZs5NLXwEfnxDTVZW/ijfF2qDozAmYQHZqbeyhJX7YlO6nYjWRBxqBeqAMHhtu3PkiysSCCUymhJ2uDHUAox+BT8IGE3sCKYIXRdmSFoibgQad9AHsQ6OLoIaNgMV7rspdBcO/CjyCkHN440XhQKz/Sq2SyygI9Qkuz0qDdQOgIraVi//EXDAvij0QXlkmh+3xBJwEqt8Pe1KP9itwvGyzGX/aAheCBSf7HPcLzJUgcWymW6FL4AE0KqNVb8Q8ahaEM5UgbXUCauDON8H4OR1Zngszw128wklwxOr7q5gB++Ks1OQlHMGgiVYZ2wC0DXlx68BKSMNnJRHWCI4r63a3bAWGCqKbcCHpimjPAHisPoaoHffVUaIpj65klj+GkoHAgo/pl0S6o4OqVpOau3Qkn95D1KDbUiE1l0HdgZaRmOKRvTKec1V3tfB2rA83Q1cZCWC5ZSwk3wihYPywMyIo6G8f2M2bFot7k/sS9ZMSle6oZDrc6A8qWnaxMZYbEXdFGy02550vdymshJ9RpSLfK1oBKoKk7yL2hk1UHm6obXYXn/F0KvDr7nAM6gOf9NnOrPHKt14WDb0GsZwNd34g1RCcBUcXewh4ZJOHerzsS2h3D30BNQUNCaF8ZQr6FYXp7v9gnQ== openpgp:0x7B7F7988" ];


  environment.systemPackages = with pkgs; [
    # Editors
    vim nano

    # Always useful
    git
  ];

  networking.firewall.rejectPackets = true;

  # We have unreliable hard disks everywhere!
  services.smartd.enable = true;

  # enable sudo?

  system.stateVersion = "17.09";
}
