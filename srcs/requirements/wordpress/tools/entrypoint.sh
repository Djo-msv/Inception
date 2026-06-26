#!bin/sh

wp core download --path="/var/www/html" --allow-root

wp config create --dbname=wordpressdb --dbuser=wp --dbpass=1234 --dbhost=mariadb:3306 --path="/var/www/html" --skip-check --allow-root

wp core install --url=jmassavi.42.fr --title=leSiteaJoJo --admin_user=supervisor --admin_password=strongpassword --admin_email=caca@gmail.com --path="/var/www/html" --allow-root

wp user create jojo coco@gmail.com --user-pass=1234 --path="/var/www/html" --role=contributor --allow-root

exec php-fpm84 -F
