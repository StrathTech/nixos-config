{
  services.nix-serve.enable = true;
  networking.firewall.allowedTCPPorts = [ 5000 ];
}
