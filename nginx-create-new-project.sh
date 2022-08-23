#!/bin/bash
pname=$1
echo $pname
mkdir /home/$USER/workspace/www/html/$pname
echo "127.0.0.1   $pname.test"  | tee -a /etc/hosts
sudo cat <<EOF > /etc/nginx/sites-available/$pname.test
server {
	listen 80;
	listen [::]:80;

	server_name $pname.test www.$pname.test;

	root /var/www/html/$pname;
	index index.php index.html;

	location / {
		try_files $uri $uri/ =404;
	}
location ~ \.php$ {
  try_files $fastcgi_script_name =404;
  include fastcgi_params;
  fastcgi_pass  unix:/run/php/php8.1-fpm.sock;
  fastcgi_index index.php;
  fastcgi_param DOCUMENT_ROOT  $realpath_root;
  fastcgi_param SCRIPT_FILENAME   $realpath_root$fastcgi_script_name; 
}
}
EOF
ln -s /etc/nginx/sites-available/$pname.test /etc/nginx/sites-enabled/
