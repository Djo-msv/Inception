FROM alpine:3.22.4

RUN apk add --no-cache mariadb mariadb-client

COPY tools/entrypoint.sh /bin/entrypoint.sh
COPY conf/mysql.cnf /etc/my.cnf.d/mysql.cnf

RUN chmod +x /bin/entrypoint.sh
RUN mkdir -p /run/mysqld
RUN mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql

USER mysql

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["mariadbd"]
