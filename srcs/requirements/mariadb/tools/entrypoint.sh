#!/bin/sh
#base on official image, from https://github.com/MariaDB

docker_check_env() {
	MYSQL_PASSWORD=$(cat /run/secrets/mariadb_password)
	if [ -z "$MYSQL_DB" ]; then
		export MYSQL_DB=db
	fi
	if [[ -z "$MYSQL_USER" ]] || [[ -z "$MYSQL_PASSWORD" ]]; then
		echo "Mysql User or Password is missing"
		exit 1
	fi
}

wait_db() {
    i=30
    while [ $i -gt 0 ]; do
        mariadb --socket=/var/run/mysqld/mysqld.sock -e "SELECT 1;" > /dev/null 2>&1 && break
        echo "Waiting for MariaDB... ($i)"
        sleep 1
        i=$((i - 1))
    done
    if [ "$i" = 0 ]; then
        echo "Unable to start server."
        exit 1
    fi
}

_main() {
	docker_check_env

	if [ -f "/var/lib/mysql/mysql/init_manifesto" ]; then
		echo "Database already Initialize"
	else
		mariadb-install-db --user=mysql --datadir=/var/lib/mysql
		mariadbd --user=mysql --datadir=/var/lib/mysql --port=3306&

		wait_db

		echo "DB=$MYSQL_DB USER=$MYSQL_USER PASSWORD=$MYSQL_PASSWORD"
		echo "=== Début setup SQL ==="
		mariadb --socket=/var/run/mysqld/mysqld.sock << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DB};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
		echo "=== Setup SQL terminé, code retour : $? ==="
		mariadb-admin --socket=/var/run/mysqld/mysqld.sock shutdown
		touch /var/lib/mysql/mysql/init_manifesto
	fi

	exec "$@"
}

_main "$@"
