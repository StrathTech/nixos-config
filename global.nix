{ config, pkgs, ... }:
{
  imports = [ /etc/nixos/hardware-configuration.nix ];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  time.timeZone = "Europe/London";

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
}
