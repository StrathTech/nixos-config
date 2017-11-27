{ config, pkgs, ... }:

{
  imports = [
    ../global.nix
    ../ldap.nix
    ../homedirs.nix
    <nixpkgs/nixos/modules/installer/netboot/netboot.nix>
  ];

  /*
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
  */

  environment.systemPackages = with pkgs; [
    #neovim
    #xonotic
  ];

  services.xserver = {
    #enable = true;
    layout = "gb";
    xkbOptions = "eurosign:e";
    #desktopManager.plasma5.enable = true;
  };

  # Get hostname via DHCP
  networking.hostName = "";

  # Fancy shells
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # disable password-authenticated remote login because ketchum's login details are public
  services.openssh.passwordAuthentication = false;

  users.extraUsers.ketchum = {
    isNormalUser = true;
    uid = 1000;
    password = "password1";
  };
  security.sudo.enable = true;

  nix.binaryCaches = [ "http://kakuna.strathtech.co.uk:5000/" "https://cache.nixos.org" ];
  nix.trustedBinaryCaches = [ "http://kakuna.strathtech.co.uk:5000/" ];
}
