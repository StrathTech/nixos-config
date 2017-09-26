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
  system.activationScripts.linkShells = ''
    ln -sf ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';
}
