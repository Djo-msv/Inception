FROM alpine:3.22.4

RUN addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx

RUN apk update && apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl/
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/CN=jmassavi.42.fr"

COPY tools/entrypoint.sh /bin/entrypoint.sh
COPY conf/nginx.conf /etc/nginx/http.d/nginx.conf

RUN chmod +x /bin/entrypoint.sh

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT ["/bin/entrypoint.sh"]
