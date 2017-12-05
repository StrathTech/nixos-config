{ config, pkgs, lib, ... }:
let
  inherit (lib) pathExists readFile optionalString mkBefore;
  inherit (config.networking) hostName;
  imagePath = ./motds + "/${hostName}.png";
  motdSnippet = optionalString (pathExists imagePath) (readFile (pkgs.imageToAnsi hostName imagePath));
in {
  nixpkgs.overlays = [ (import ./motds/overlay.nix) ];
  users.motd = mkBefore motdSnippet;
}
