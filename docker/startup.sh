#!/bin/bash

if [ ! -e /var/www/test/.env ]; then
	cp /var/www/test/.env.base /var/www/test/.env
fi

cd /var/www/test;
/usr/local/bin/composer install

systemctl start mariadb
systemctl start nginx
systemctl start php-fpm
systemctl start sshd

if [ "init" = "$1" ]; then
	mysql -u root < /tmp/init.sql
	php artisan migrate:refresh --seed
fi