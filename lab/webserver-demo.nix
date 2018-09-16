{config, pkgs, ...}:
{
  networking.firewall.allowedTCPPorts = [ 80 ];
  services.nginx = {
    enable = true;
    virtualHosts.demo = {
       root = "/var/www";
       locations."~ \\.php$".index = "index.php";
       locations."~ \\.php$".extraConfig = ''
         include ${pkgs.nginx}/conf/fastcgi_params;

         fastcgi_split_path_info ^(.+\\.php)(/.+)$;
         fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_name;
         fastcgi_pass unix:/run/phpfpm.sock;
         fastcgi_index index.php;
       '';
    };
  };
  services.phpfpm.pools.demo = {
    listen = "/run/phpfpm.sock";
    extraConfig = ''
      listen.owner = nginx
      user = nobody
      pm = static
      pm.max_children = 4
    '';
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
