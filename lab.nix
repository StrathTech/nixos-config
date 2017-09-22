{ config, pkgs, ... }:

{
  imports = [
    ./global.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  environment.systemPackages = with pkgs; [
    neovim
    xonotic
  ];

  services.xserver = {
    enable = true;
    layout = "gb";
    xkbOptions = "eurosign:e";
    desktopManager.plasma5.enable = true;
  }

  # Fancy shells
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # disable remote login because mrpoo's login details are public
  services.openssh.enable = false;

  users.extraUsers.ketchum = {
    isNormalUser = true;
    uid = 1000;
    password = "password1";
  };
  security.sudo.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";
}
