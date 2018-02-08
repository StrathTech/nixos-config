let pkgs = import <nixpkgs> {};
  target-i686 = import <nixpkgs/nixos> { system = "i686-linux"; configuration = ./lab.nix; };
  target-x86_64 = import <nixpkgs/nixos> { system = "x86_64-linux"; configuration = ./lab.nix; };
in {
  system-i686 = target-i686.config.system.build.toplevel;
  system-x86_64 = target-x86_64.config.system.build.toplevel;
  ipxe = pkgs.callPackage ./ipxe.nix {};
}
