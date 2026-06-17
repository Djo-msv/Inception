FROM alpine:3.22.4

COPY tools/entrypoint.sh /bin/
COPY conf/mysql.cnf /etc/mysql.cnf

RUN chmod 777 /bin/entrypoint.sh
RUN chmod 777 /etc/mysql.cnf

RUN apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld

RUN mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["mariadbd"]
