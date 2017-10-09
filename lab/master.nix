{ pkgs, lib, ... }:
let
  lab-machines = import ./machine-info.nix;

  target = import <nixpkgs/nixos> { configuration = ./lab.nix; };

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
        set timeout=1
        menuentry "NixOS" {
          echo "Loading kernel..."
          linux (pxe)/bzImage ${toString target.config.boot.kernelParams}
          echo "Loading initramfs..."
          initrd (pxe)/initrd
          echo "Booting..."
        }
        EOF
        # cp target.kernel $out
        # cp target.initrd $out
        grub-mkimage --format=i386-pc-pxe -o $out/grub.pxe --prefix="(pxe)/" pxe net tftp normal linux
        ln -s ${pkgs.grub2}/lib/grub/i386-pc $out/
      '';

in {
  services.dnsmasq.enable = true;
  services.dnsmasq.extraConfig = ''
    interface=enp5s0
    keep-in-foreground
    #log-facility=-
    dhcp-hostsfile=${hosts}

    dhcp-range=10.123.0.10,10.123.0.200,6h

    dhcp-boot=grub.pxe
    enable-tftp
    tftp-root=${tftp-root}

    # If we're not a router, send these.
    #dhcp-option=3
    #dhcp-option=6
    #port=0
  '';
}
