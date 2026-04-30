FROM alpine:3.22

EXPOSE 3660

COPY tools/mdb_entrypoint.sh /usr/local/bin/mdb_entrypoint.sh
#COPY conf/my.cnf /etc/mysql/my.cnf
#VOLUME ./data /var/data

RUN apk add mariadb mariadb-client
RUN chmod +x /usr/local/bin/mdb_entrypoint.sh

ENTRYPOINT ["sh", "/usr/local/bin/mdb_entrypoint.sh"]
