FROM alpine:3.22

COPY tools/mdb_entrypoint.sh /usr/local/bin/mdb_entrypoint.sh

RUN apk add mariadb mariadb-client
RUN chmod +x /usr/local/bin/mdb_entrypoint.sh

#ENTRYPOINT ["/usr/local/bin/mdb_entrypoint.sh"]
