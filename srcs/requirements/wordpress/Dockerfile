FROM alpine:3.22.4

COPY tools/entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache \
	php84 \
	php84-fpm \
	php84-mysqli \
	php84-json \
	php84-openssl \
	php84-curl \
	php84-zlib \
	php84-xml \
	php84-phar \
	php84-intl \
	php84-dom \
	php84-xmlreader \
	php84-ctype \
	php84-session \
	php84-mbstring \
	php84-gd \
	php84-zip \
	php84-exif \
	php84-fileinfo \
	php84-tokenizer \
	php84-simplexml \
	curl \
	mariadb-client

RUN adduser -S -G www-data www-data

RUN mkdir -p /var/log/php84
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/log/php84
RUN chown -R www-data:www-data /var/www/html

RUN mv /usr/bin/php84 /usr/bin/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY conf/php.ini /etc/php84/php.ini
COPY conf/www.conf /etc/php84/php-fpm.d/

RUN mkdir -p /var/www/html
RUN wp core download --path="/var/www/html" --allow-root

USER www-data

ENTRYPOINT ["/bin/entrypoint.sh"]
