let pkgs = import <nixpkgs> {};
  target-i686 = import <nixpkgs/nixos> { system = "i686-linux"; configuration = ./lab.nix; };
  target-x86_64 = import <nixpkgs/nixos> { system = "x86_64-linux"; configuration = ./lab.nix; };
in {
  system-i686 = target-i686.config.system.build.toplevel;
  system-x86_64 = target-x86_64.config.system.build.toplevel;
  initrd-i686 = target-i686.config.system.build.netbootRamdisk;
  initrd-x86_64 = target-x86_64.config.system.build.netbootRamdisk;
  ipxe = pkgs.callPackage ./ipxe.nix {};
}
