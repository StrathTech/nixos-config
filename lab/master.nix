{ pkgs, lib, ... }:
let
  lab-machines = import ./machine-info.nix;

  target-i686 = import <nixpkgs/nixos> { system = "i686-linux"; configuration = ./lab.nix; };
  target-x86_64 = import <nixpkgs/nixos> { system = "x86_64-linux"; configuration = ./lab.nix; };

  hosts = pkgs.writeText "hosts"
    (lib.foldl' ( {ip, text}: {name, mac, ...}: {
                    ip = ip + 1; text = text + "${mac},10.123.0.${toString ip},${name}\n";
                  })
                { ip = 10; text = "";}
                lab-machines.as-list
    ).text;

    tftp-root = pkgs.runCommand
      "tftproot"
      { buildInputs = with pkgs; [ grub2 perl ]; }
      ''
        mkdir $out
        cat > $out/grub.cfg <<EOF
        set timeout=5
        if cpuid -l ; then
          menuentry "NixOS 64-bit" {
            echo "Loading kernel..."
            linux (pxe)/bzImage-x86_64 ${toString target-x86_64.config.boot.kernelParams} init=${target-x86_64.config.system.build.toplevel}/init
            echo "Loading initramfs..."
            initrd (pxe)/initrd-x86_64
            echo "Booting..."
          }
        fi
        menuentry "NixOS 32-bit" {
          echo "Loading kernel..."
          linux (pxe)/bzImage-i686 ${toString target-i686.config.boot.kernelParams} init=${target-i686.config.system.build.toplevel}/init
          echo "Loading initramfs..."
          initrd (pxe)/initrd-i686
          echo "Booting..."
        }
        EOF
        ln -s ${target-i686.config.system.build.kernel}/bzImage $out/bzImage-i686
        ln -s ${target-i686.config.system.build.netbootRamdisk}/initrd $out/initrd-i686
        ln -s ${target-x86_64.config.system.build.kernel}/bzImage $out/bzImage-x86_64
        ln -s ${target-x86_64.config.system.build.netbootRamdisk}/initrd $out/initrd-x86_64
        cat >> $out/boot-i686.ipxe <<EOF
        #!ipxe
        kernel http://netboot.strathtech.co.uk/bzImage-i686 ${toString target-i686.config.boot.kernelParams} init=${target-i686.config.system.build.toplevel}/init
        initrd http://netboot.strathtech.co.uk/initrd-i686
        boot
        EOF
        cat >> $out/boot-x86_64.ipxe <<EOF
        #!ipxe
        kernel http://netboot.strathtech.co.uk/bzImage-x86_64 ${toString target-x86_64.config.boot.kernelParams} init=${target-x86_64.config.system.build.toplevel}/init
        initrd http://netboot.strathtech.co.uk/initrd-x86_64
        boot
        EOF
        grub-mkimage --format=i386-pc-pxe -o $out/grub.pxe --prefix="(pxe)/" pxe net tftp normal linux
        ln -s ${pkgs.grub2}/lib/grub/i386-pc $out/
        ln -s ${pkgs.callPackage ./ipxe.nix {}}/* $out/
      '';

in {
  system.extraSystemBuilderCmds = ''
    ln -s ${tftp-root} $out/netboot
  '';
  services.nginx.enable = true;
  services.nginx.virtualHosts."netboot.strathtech.co.uk" = {
    #enableACME = true;
    #addSSL = true;
    root = "/var/lib/tftp";
  };
  services.dnsmasq.enable = true;
  networking = {
    firewall.allowedUDPPorts = [ 53 67 69 ];
    firewall.allowedTCPPorts = [ 80 443 ];
    interfaces.enp5s0.ip4 = [ { address = "10.123.0.1"; prefixLength = 24; } ];
    nat.enable = true;
    nat.externalInterface = "enp4s0";
    nat.internalInterfaces = [ "enp5s0" ];
  };

  # https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml is useful
  services.dnsmasq.extraConfig = ''
    interface=enp5s0
    keep-in-foreground
    #log-facility=-
    dhcp-hostsfile=${hosts}

    dhcp-authoritative
    dhcp-range=10.123.0.100,10.123.0.200,24h

    dhcp-boot=undionly.kpxe
    enable-tftp
    #tftp-root=${tftp-root}
    tftp-root=/var/lib/tftp

    # ntp[10].net.strath.ac.uk
    dhcp-option=42,130.159.228.123,130.159.248.123

    # If we're not a router, send these.
    #dhcp-option=3
    #dhcp-option=6
    #port=0
  '';
}
