#!/bin/sh

_docker_check_env() {
	USER_PASSWORD=$(cat /run/secrets/wordpress_user_password)
	ADMIN_PASSWORD=$(cat /run/secrets/wordpress_admin_password)
	DB_PASSWORD=$(cat /run/secrets/wordpress_db_password)

	if [ -z "$USER_PASSWORD" ]; then
		echo "User can't have empty password"
		exit 1;
	fi
	if [ -z "$ADMIN_PASSWORD" ]; then
		echo "Admin can't have empty password"
		exit 1;
	fi
	if [ -z "$DB_PASSWORD" ]; then
		echo "Db can't have empty password"
		exit 1;
	fi
	if [ -z "$WORDPRESS_USER" ]; then
		export WORDPRESS_USER=wp_user
	fi
	if [ -z "$WORDPRESS_USER_EMAIL" ]; then
		export WORDPRESS_USER_EMAIL=user@email.com
	fi
	if [ -z "$WORDPRESS_ADMIN" ]; then
		export WORDPRESS_ADMIN=wp_admin
	fi
	if [ -z "$WORDPRESS_ADMIN_EMAIL" ]; then
		export WORDPRESS_ADMIN_EMAIL=admin@email.com
	fi
	if [ -z "$WORDPRESS_DB_NAME" ]; then
		export WORDPRESS_DB_NAME=wp_db
	fi
	if [ -z "$SITE_NAME" ]; then
		export SITE_NAME=site
	fi
}

wait_db() {
    i=30
    while [ $i -gt 0 ]; do
        mariadb -h mariadb -u ${WORDPRESS_USER} -p${DB_PASSWORD} -e "SELECT 1;" > /dev/null 2>&1 && break
        echo "Waiting for MariaDB... ($i)"
        sleep 1
        i=$((i - 1))
    done
    if [ "$i" = 0 ]; then
        echo "Unable to connecte dataBase."
        exit 1
    fi
}

_main() {
	_docker_check_env

	wait_db
	if [ -f "/var/www/html/wp-config.php" ]; then
		echo "Wordpress already Initialize"
	else

		wp config create --dbname=${WORDPRESS_DB_NAME} --dbuser=${WORDPRESS_USER} --dbpass=${DB_PASSWORD} --dbhost=mariadb:3306 --path="/var/www/html" --skip-check

		wp core install --url=jmassavi.42.fr --title=${SITE_NAME} --admin_user=${WORDPRESS_ADMIN} --admin_password=${ADMIN_PASSWORD} --admin_email=caca@gmail.com --path="/var/www/html"

		wp user create ${WORDPRESS_USER} ${WORDPRESS_USER_EMAIL} --user_pass=${USER_PASSWORD} --path="/var/www/html" --role=contributor
	fi
	exec php-fpm84 -F
}

_main "$@"
