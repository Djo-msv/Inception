#!/bin/sh

#https://wiki.alpinelinux.org/wiki/MariaDB

#Initialize MySQL Data Directory.
mariadb-install-db --user=mysql --datadir=/var/lib/mysql
#Start the main service. At this point there will be no root password set.
rc-service mariadb start

mariadb-secure-installation
#Add MariaDb to OpenRC.
rc-update add mariadb default


