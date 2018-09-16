{ config, pkgs, ... }:

{
  imports = [
    ../global.nix
    <nixpkgs/nixos/modules/installer/netboot/netboot.nix>
    ../wakeonlan.nix
  ];

  /*
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
  */
  boot = {
    /*
    kernelPackages = pkgs.linuxPackagesFor (pkgs.linux.override {
      extraConfig = ''
        E1000E y
      '';
    });
    */

    supportedFilesystems = [ "zfs" ];
    initrd.preDeviceCommands = "head -c 4 /dev/urandom > /etc/hostid";
    initrd.postMountCommands = "mkdir -p /mnt-root/etc && cp /etc/hostid /mnt-root/etc/hostid";
  };
  networking.hostId = "deadbeef"; # dummy

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

  services.openssh.enable = true;
  # disable password-authenticated remote login because ketchum's login details are public
  services.openssh.passwordAuthentication = false;

  # For badblocks testing project
  users.users.root.openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8ze/k7b5MHnWCpmsbJZosSWBHnRJfTkUNlUzvoyP76ANC6oFNdYiUUlDzmECqAjBZm1nYJygAlroYfnZuCP16JgiRBfuiQwv8Mp0aRmDjXgrbD7/pfreofd+rlu5HIe6edsYW2KSfVh9AAqUBibCCtsX0sb1SNzMDLNVlKogtmgEMhcm5uwGPtaiohFHEC51HRxT5HGLwEWvhDs6eTl9R5n/Ougb30rB3wzLmDaJZDJ/4PYEIHoLZhcWCMKiYzSbCxzxeHaPhP1LdaB1Q5uQYQC92ZiHxxKfO3LZnNC3U6qH7GxBJinnfkA2T69PRL6eeTLZZyDnI/0pwPUc4HfpP lheckemann@squirtle"];

  users.extraUsers.ketchum = {
    isNormalUser = true;
    uid = 1000;
    password = "password1";
    extraGroups = [ "sudo" ];
  };
  security.sudo.enable = true;

  nix.binaryCaches = [ "http://kakuna.strathtech.co.uk:5000/" "https://cache.nixos.org" ];
  nix.trustedBinaryCaches = [ "http://kakuna.strathtech.co.uk:5000/" ];
}
