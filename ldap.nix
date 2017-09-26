{ config, pkgs, ... }:
{
  users.ldap = {
    enable = true;
    base = "dc=strathtech,dc=co,dc=uk";
    server = "ldap://ldap.strathtech.co.uk/";
    nsswitch = true;
    loginPam = true;    
  };

  security.pam.services.ldap.makeHomeDir = true;

  # So that the LDAP shell entries can be found
  system.activationScripts.linkShells = ''
    ln -sf ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';

  security.sudo.extraConfig = ''
    %SysAdminWG      ALL=(ALL:ALL) SETENV: ALL
  '';
}
